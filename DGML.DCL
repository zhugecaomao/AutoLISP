
parts : dialog {
	label	= "Parts Library";
	: column {
	  : row {
	    : column {
	      : list_box {
                 label 			= "Parts select:";
                 key 			= "list_parts";
                 width 			= 20;
                 height 		= 5;}
	      : toggle {
		label    		= "Rotate 180";
		value 			= "0";
		key			= "rota";}
	    }  
	    : image_button{
	       color 			= 0;
	       key 			= "ima_parts";
	       height 			= 8;
	       width 			= 25;}
	  }
	  : row {
	    : popup_list {
	       horizontal_alignment     = left;
	       mnemonic  		= "N";
	       label     		= "Nom. Size: ";
	       key       		= "size_parts";
	       edit_width		= 10;}
	    : edit_box {
	       fixed_width       	= true;
	       mnemonic  		= "O";
	       label     		= "Length: ";
	       key       		= "len_parts";
	       edit_width		= 10;
	       horizontal_alignment     = left;
	       allow_accept             = true;}
          }
  	  spacer_1;
	  ok_cancel;
} 	}
	    

