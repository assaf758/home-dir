// This macro adds files from a file-list into the current project.
// It is useful for large code-bases where it can save the hassle of adding
// various dirs over and over (follows the "cscope way").
// Usage - from slick-edit command line: addf <filename> . filename should
// contain a list of files, each in a separate line. To create this file,
// use (for example): find . -name "*.[ch]" -follow -print > vs_list.txt

#include "slick.sh"

void build_tag_from_filelist (_str filelist)
{
    int orig_view_id=0, list_view_id=0, res=0;
    _str tag_filename=_GetWorkspaceTagsFilename();

    if (tag_filename == '') {
        _message_box("addf: No project open","Error",MB_OK|MB_ICONEXCLAMATION);
        return;
    }

    // opens a file-list as a temporary view
    _open_temp_view(filelist,list_view_id,orig_view_id);

    tag_add_viewlist(tag_filename,list_view_id);
}


_command void addf(_str file_list='')
{
   
    if (file_list == '') {
        _message_box("Usage: addf <Filename>\nFilename contains a list of files"
                     ,"Error",MB_OK|MB_ICONEXCLAMATION);
        return ;
    }

    if (!file_exists(file_list)) {
        msg=nls("addf: File \"%s\" does not exist, please provide a valid ":+
                "filename",file_list);
        _message_box(msg,"Error",MB_OK|MB_ICONEXCLAMATION);
        return ;
    }
   
    build_tag_from_filelist(file_list);

}

