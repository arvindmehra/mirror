$("#filter_condition").empty().append("<%= escape_javascript(render :partial => 'filter_list') %>")