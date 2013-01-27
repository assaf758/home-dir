#include 'slick.sh'

// clipboard_type == 'CHAR' , 'LINE' or 'BLOCK'
_command int text_to_clipboard (_str text = '', boolean doAppend = false, _str clipboard_type = 'CHAR', _str clipboard_name = '', boolean quiet = false) name_info(','VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   // s.th. to copy ?
   if ( length ( text ) )
   {
      if ( !doAppend )  push_clipboard_itype (clipboard_type,clipboard_name,1,true);
      append_clipboard_text (text);
      if ( !quiet ) message ( "'" text "' " (doAppend ? "appended" : "copied") " to clipboard [" clipboard_type "]");
      return(0);
   }
   else return(TEXT_NOT_SELECTED_RC);
}

// current tag/symbol
_command void cct ( boolean inclArgs = false ) name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   text_to_clipboard ( current_tag ( false, inclArgs ) );
}

// current buffer
_command void ccb () name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   text_to_clipboard (strip_filename (p_buf_name,'DP'));
}

// current buffer full name
_command void ccbf () name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   text_to_clipboard (p_buf_name);
}

// current source location
_command void ccs ( boolean inclArgs = false ) name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   cur_tag = current_tag ( false, inclArgs );
   cur_src = strip_filename (p_buf_name,'DP') " - " cur_tag " [line " p_RLine "]:";
   text_to_clipboard ( cur_src );
}

// current source location - for gdb
_command void ccs1 ( boolean inclArgs = false ) name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   cur_tag = current_tag ( false, inclArgs );
   cur_src = strip_filename (p_buf_name,'DP') ":" p_RLine;
   text_to_clipboard ( cur_src );
}

// current buffer full path + location - for gdb
_command void ccbf1 ( boolean inclArgs = false ) name_info (','VSARG2_MARK|VSARG2_TEXT_BOX|VSARG2_REQUIRES_EDITORCTL|VSARG2_READ_ONLY)
{
   cur_tag = current_tag ( false, inclArgs );
   cur_src = p_buf_name ":" p_RLine;
   text_to_clipboard ( cur_src );
}
