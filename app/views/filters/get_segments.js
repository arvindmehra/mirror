$("#filter_segment").empty().append("<%= escape_javascript(render :partial => 'segment_list') %>")