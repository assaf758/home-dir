/*
 * sync_project_with_scm.e
 *
 * Update the current project's file list, based on dir list definitions in
 *
 * Usage:
 *
 * Use "ssync" to sync the current project.
 * Assumes slickedit project is created in directory in the workspace root
 * and cscope.files is at workspace root
 */

#include "slick.sh"


/**
 * Static variables.
 */
static boolean s_fReloadIni = true;
static int s_idIni = -1;
static int s_isDebugging = 0;

definit()
{
   if(arg(1) != 'L')
      s_idIni = -1;
   s_fReloadIni = true;
}

/**
 * Structure that defines one directory to scan.
 * @see translate_wildcard_list
 */
struct DIRINFO
{
   boolean fRecurse;    // Scan recursively.
   boolean fExclude;    // "dir" is really a prefix to exclude.
   _str dir;            // Directory to scan.
   _str filespec;       // Optional wildcards (see translate_wildcard_list).
   _str file_list;      // A file containing list of file-names
};

/**
 * Structure for keeping track of cumulative totals while updating projects.
 */
struct CUMULATIVETOTALS
{
   int cAdded;
   int cRemoved;
   int cTotal;
};

/**
 * Update the file lists for the projects in the current workspace.  Only
 * projects in the "projects" array (near the top of this macro source file)
 * are updated.
 *
 */
_command void ssync() name_info(','VSARG2_REQUIRES_PROJECT_SUPPORT)
{
   s_fReloadIni = true;

   //$ todo: (chrisant) Parse the arguments to determine whether to enable
   // debug output.
   s_isDebugging = 0;

   if(_workspace_filename == '')
   {
      message("No workspace open.");
      return;
   }

   // Get the list of projects to sync.
   int status;
   _str arrayProjects[] = null;
   if(arg(1) == '-a')
   {
      status = _GetWorkspaceFiles(_workspace_filename,arrayProjects);
      if(status)
      {
         _message_box(nls("ssync: Unable to get projects from workspace '%s'.\n\n%s", _workspace_filename, get_message(status)));
         return;
      }
   }
   else if(arg() == 0)
   {
      if(_project_name != '')
         arrayProjects[0] = _project_name
   }
   else
   {
      _message_box("ssync: Syntax error.\n\nUsage:  ssync [-a]\n\nThe -a flag syncs all projects in the workspace.\nOtherwise only syncs the current project.");
      return;
   }
   if(!arrayProjects._length())
   {
      message("No projects to sync.");
      return;
   }

   // Loop over the projects.
   int ii;
   _str filename = '';
   _str displayname = '';
   CUMULATIVETOTALS totals;
   totals.cAdded = 0;
   totals.cRemoved = 0;
   totals.cTotal = 0;
   for (ii = 0; ii < arrayProjects._length(); ii++)
   {
      filename = _AbsoluteToWorkspace(strip_filename(arrayProjects[ii], 'E') :+ PRJ_FILE_EXT);
      displayname = GetProjectDisplayName(arrayProjects[ii]);

      message("Scanning project '"displayname"' ("ii+1"/"arrayProjects._length()")...");

      if (s_isDebugging)
         say("Scanning project '"filename"'...");

      ssync_project(filename, totals);
   }

   // Report cumulative results.
   message("Ssync completed for ":+
           arrayProjects._length() " project(s)  /  files: " :+
           totals.cAdded " added, " :+
           totals.cRemoved " removed, " :+
           totals.cTotal " total.");
}

static void ssync_project(_str project, CUMULATIVETOTALS& totals)
{
   // Add the project's dir list.
   _str wksName = strip_filename(_workspace_filename, 'PE');
   _str projName = strip_filename(project, 'PE');
   DIRINFO dir_list[];

   {
      _str file_list_path=_parent_path(_file_path(project)) :+ "cscope.files";
      if (s_isDebugging)
      {
         say("project is " project);
         say("file_list is: " file_list_path);
      }

      DIRINFO di;
      di.file_list = file_list_path;
      dir_list[dir_list._length()] = di;
   }


   // Change to the project file's directory so relative paths can work.
   int status;
   _str old_cwd = getcwd();
   _str prj_root = strip_filename(project, 'NE');
   if(prj_root != '')
   {
      status = chdir(prj_root, 1);
      if(status)
      {
         _message_box(nls("ssync: Could not change to directory '%s'.", prj_root));
         return;
      }
   }

   // Update the project file list.
   status = ssync_worker(project, dir_list, totals);
   if (status)
   {
      _message_box(nls("ssync: Error updating project '%s'.\n\n%s", project, get_message(status)));
   }

   // Restore the original working directory.
   if(prj_root != '' && old_cwd != '')
   {
      status = chdir(old_cwd, 1);
      if(status)
      {
         _message_box(nls("ssync: Could not change back to directory '%s'.", old_cwd));
         return;
      }
   }
}

/**
 * Updates the file list for the specified project.
 *
 * @param project       The project to update.
 * @param dir_list      The dir list to use to update the project file list.
 *
 * @return int          Returns status code (0 for success, else failure).
 */
static int ssync_worker(_str project, DIRINFO (&dir_list)[], CUMULATIVETOTALS& totals)
{
   // Get list of current project files.
   int projectfiles_list:[];
   ssync_getprojectfilelist(project, projectfiles_list);

   if(s_isDebugging >= 6) {
      _str filename1;
      for(filename1._makeempty();;)
      {
         projectfiles_list._nextel(filename1);
         if(filename1._isempty())
            break;
         say('proj-content:  "'filename1'"');
      }
   }

   int ii = 0;
   _str exclude_list[];

   int filelist_view_id = 0;
   int orig_view_id = 0;


   // Check if it's a file-list
   _str file_list = dir_list[0].file_list;
   if(file_list!='') {
      if (!file_exists(file_list)) {
         msg=nls("ssync: File \"%s\" does not exist, please provide a valid ":+"filename",file_list);
        _message_box(msg,"Error",MB_OK|MB_ICONEXCLAMATION);
        return 1;
      }
      _open_temp_view(file_list,filelist_view_id,orig_view_id);
      ii++;
   } else {
      orig_view_id = _create_temp_view(filelist_view_id);
   }
   fileman_mode();


   // Remove duplicate files.
   int file_list_hash:[];
   file_list_hash._makeempty();

   top();
   up();
   while(!down())
   {
      _str filename;
      get_line(filename);
      filename = stranslate(filename, FILESEP, FILESEP2);
      filename = strip(filename, 'B');
      filename = strip(filename, 'B','"');
      if(_fpos_case != '')
      {
         filename = lowcase(filename);
      }

      if(s_isDebugging >= 6) {
         say('got 'filename'');
         say(projectfiles_list._indexin(filename));
      }

      if(projectfiles_list._indexin(filename))
      {
         // If this file is current in the project, set the projectfiles_list
         //  entry to 1 (so we don't remove it from the project) and then
         //  remove this entry from the temp buffer add list.
         projectfiles_list:[filename] = 1;

         delete_line();
         if(s_isDebugging >= 6)
            say('delete-current "'filename'"');
         up();
      }
      else if(file_list_hash._indexin(filename) &&
         file_list_hash:[filename] != p_line)
      {
         // This is a new file and it's a duplicate so whack it.
         delete_line();
         if(s_isDebugging >= 6)
            say('delete-duplicate "'filename'"');
         up();
      }
      else
      {
         // New file: record the line number we first saw it at.
         file_list_hash:[filename] = p_line;
      }
   }

   // Create a list of files to remove from the project. Every hash entry
   //  in projectfiles_list[] that is a 0 should be removed.
   _str filename;
   _str filelist_remove = "";
   int files_removed = 0;
   for(filename._makeempty();;)
   {
      projectfiles_list._nextel(filename);
      if(filename._isempty())
         break;
      if(projectfiles_list:[filename] != 0)
         continue;

      if(s_isDebugging >= 1)
         say('remove:  "'filename'"');

      files_removed++;
      //$ PERF: (chrisant) String growth has exponential cost here unless
      // Slick-C is using geometric growth under the covers.  However, the
      // number of files removed should typically be small, so this may be
      // acceptable.
      filelist_remove = filelist_remove " " maybe_quote_filename(filename);
   }
   if(filelist_remove != "")
   {
      filelist_remove = strip(filelist_remove, 'B');

      int status = project_remove_filelist(project, filelist_remove);
      if(status != 0)
      {
         _message_box(nls("ssync: Warning: Unable to remove files from project.\n\n%s", get_message(status)));
      }
   }

   // Add the new list of files to our project.
   if(file_list_hash._length())
   {
      if(s_isDebugging >= 1)
      {
         _str line;
         filelist_view_id.top();
         do
         {
            filelist_view_id.get_line(line);
            if(line != '')
               say('add:     "'strip(line)'"');
         }
         while(!filelist_view_id.down());
      }

      tag_add_viewlist(_GetWorkspaceTagsFilename(), filelist_view_id, project);
   }
   else
   {
      _delete_temp_view(filelist_view_id);
   }

   int project_filecount = projectfiles_list._length() - files_removed + file_list_hash._length();

#if 0
   message("Ssync completed: " file_list_hash._length() " files added, " :+
           files_removed " files removed, " :+
           project_filecount " files total.");
#endif

   totals.cAdded += file_list_hash._length();
   totals.cRemoved += files_removed;
   totals.cTotal += project_filecount;

   activate_window(orig_view_id);
   return(0);
}

/**
 * Builds a hash array of the files in the project.
 */
static void ssync_getprojectfilelist(_str ProjectName, int (&projectfiles_list):[])
{
   _str filelist = "";
   int file_view_id = 0;
   int orig_view_id = p_window_id;

   GetProjectFiles(ProjectName, file_view_id);
   p_window_id = file_view_id;

   top();
   up();

   while(!down())
   {
      _str filename;

      get_line(filename);
      filename = strip(filename, 'B');

      if(filename != "")
      {
         if(_fpos_case != '')
            filename = lowcase(filename);
         projectfiles_list:[filename] = 0;
      }
   }

   p_window_id = orig_view_id;
   _delete_temp_view(file_view_id);
}

