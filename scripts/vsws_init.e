#include "slick.sh"
_command void ws_init()
{
   int res;
   _str wspath = get_env("WS");
   if (rc == STRING_NOT_FOUND_RC) {
      _message_box("Please set $WS to workspace root.\nQuiting for now.");
      exit();
   }

   message(nls("Hello-msg from slickedit. wspath = \"%s\"",wspath));
   _message_box(nls("Hello-msgbox from slickedit. wspath = \"%s\"",wspath));
   say(nls("Hello-say from slickedit. wspath = \"%s\"",wspath));

   if (_workspace_filename!='') {
      workspace_close();
   }

   _str wsfile = nls("%s/%s",wspath,"my_slick/my_proj.vpw");
   res = workspace_open(wsfile);
   if (!res) {
      _message_box(nls("Workspace \"%s\" succesfully opened!",wsfile));
   } 
   cd(wspath); 
}
