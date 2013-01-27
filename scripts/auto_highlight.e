#include "slick.sh"
int g_highlight_timer_handle = -1;

void highlight_callback()
{
	if ( _no_child_windows()
			||
		( _idle_time_elapsed() < 100 ) )
	{
		return;
	}

	int orig_wid = p_window_id;
	p_window_id = _mdi.p_child;

	static long last_seekpos;
	static int last_bufid;
	if (last_seekpos == _QROffset() && last_bufid==p_buf_id) {
	   p_window_id = orig_wid;
	   return;
	}

	// save position and search information
	typeless p;
	save_pos(p);
	typeless ss = old_search_string, sf = old_search_flags, wr = old_word_re,
		sr = old_search_reserved, sf2 = old_search_flags2;

	/////////////////////////////////////////////////////// start actual work
	clear_highlights();

	int start_col;
	_str the_cur_word = cur_word( start_col, '', true );

	// cur_word is a little too loose for my taste. Make sure that the cursor
	// is actually on a word (not the whitespace/special characters around it)
	// before highlighting anything.
	int col_as_imaginary = _text_colc( p_col, 'P' );

	if ( the_cur_word != "" )
	{
		if ( ( col_as_imaginary >= start_col )
				&&
			 ( col_as_imaginary <= start_col + the_cur_word._length() ) )
		{
			mark_all_occurences(
				the_cur_word,
				"W",
				VSSEARCHRANGE_CURRENT_BUFFER,
				MFFIND_CURBUFFERONLY,
				0,
				true,
				false, // list_all
				false // show_bookmarks
			);
		}
	}
	///////////////////////////////////////////////////////// end actual work

	old_search_string = ss;
	old_search_flags = sf;
	old_word_re = wr;
	old_search_reserved = sr;
	old_search_flags2 = sf2;

	// save our most recent buffer position and buffer ID
	last_seekpos=_QROffset();
	last_bufid=p_buf_id;

	// refresh the MDI child window, force process events to repaint
	refresh();

	// restore the original window ID
	p_window_id = orig_wid;
}


void start_auto_highlighting()
{
	g_highlight_timer_handle = _set_timer( 100, highlight_callback );
	message( "Started highlighting" );
}


void stop_auto_highlighting()
{
	_kill_timer( g_highlight_timer_handle );
	g_highlight_timer_handle = -1;

	clear_highlights();
	message( "Stopped highlighting" );
}


_command void toggle_auto_highlighting() name_info(',')
{
	if ( g_highlight_timer_handle != -1 )
	{
		stop_auto_highlighting();
	}
	else
	{
		start_auto_highlighting();
	}
}


