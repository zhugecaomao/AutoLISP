toldim : dialog {
	label	= "Select dimstyle";
	: column {
	   : radio_row {
	   	: radio_button {
	    	   label = "Horizontal";
	    	   fixed_width = true;
	    	   value = "0";
	     	   key   = "hor";}
	   	: radio_button {
	    	   label = "Vertical";
	    	   fixed_width = true;
	    	   value = "0";
	    	   key   = "ver";}
	   	: radio_button {
	    	   label = "Ordinate";
	    	   fixed_width = true;
	   	   value = "0";
	   	   key   = "ord";}
	   }
ok_cancel;
}	}

sub_toldim : dialog {
		label = "Select Tolerance";
	     : column {
	      :row{
	        : text {
		   label = "UpTolerance:     ";
	           fixed_width       	= true;
	           horizontal_alignment     = left;}
	        : text {
		   label = "BottomTolerance:";
	           fixed_width       	= true;
	           horizontal_alignment     = left;}
              }
	      :row{
	        : edit_box {
	           fixed_width       	= true;
	           key       		= "tp";
	           edit_width		= 12;
	           horizontal_alignment     = left;
	           allow_accept             = true;}
	        : edit_box {
	           fixed_width       	= true;
	           key       		= "tm";
	           edit_width		= 12;
	           horizontal_alignment     = left;
	           allow_accept             = true;}
              }
	      : row {
		   : list_box {
		       key = "tp_list";
		       width =  10;
		       fixed_height = true;}
		   : list_box {
		       key = "tm_list";
		       width =  10;
		       fixed_height = true;}
	     }
	        ok_cancel;
}	}

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
	    

a000 : dialog {
	label 	= "A000";
      : column {
	 spacer_0;
	: row {
	 : edit_box {
	      fixed_width       	= true;
	      mnemonic  		= "O";
	      label     		= "OrderNo:";
	      key       		= "ono";
	      edit_width		= 10;
	      horizontal_alignment      = left;
	      allow_accept              = true;
	 }
	 : popup_list {
	      horizontal_alignment      = left;
	      mnemonic  		= "P";
	      label     		= "PlateNO:";
	      key       		= "pno";
	      edit_width		= 10;
	      list      		= "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12";
	 }
	} 
	: row {
	 : edit_box {
	      fixed_width       	= true;
	      mnemonic  		= "H";
	      label     		= "PlateHei.:";
	      key       		= "phe";
	      edit_width		= 5;
	      horizontal_alignment      = left;
	      allow_accept              = true;
	 }
	 : popup_list {
	     mnemonic  			= "M";
	     label     			= "Mat'l:";                          
	     key       			= "pm";
	     edit_width			= 10;
	     list      			= "\nP20\nS50C\nP1\n718\n318";}
	}
	: boxed_column {
	  label 			= "Select text:";
	  : row {
	     : toggle {
		label 			= "Sel1:";
		key 			= "s1";}
	     : edit_box {
		fixed_width       	= true;
		key       		= "tx1";
		edit_width		= 13;}
	     : toggle {
		label 			= "Sel3:";
		key 			= "s3";}
	     : edit_box {
		fixed_width       	= true;
		key       		= "tx3";
		edit_width		= 13;}
	  }
	  : row {
	     : toggle {
		label 			= "Sel2:";
		key 			= "s2";}
	     : edit_box {
		fixed_width       	= true;
		key       		= "tx2";
		edit_width		= 13;}
	     : toggle {
		label 			= "Sel4:";
		key 			= "s4";}
	     : edit_box {
		fixed_width       	= true;
		key       		= "tx4";
		edit_width		= 13;}
	  }
          : row {
             : toggle {
	        label 			= "Sel5:(³ÉÐÎÇ»)";
	        key 			= "s5";}
	     : edit_box {
	        fixed_width       	= true;
	        key       		= "tx5";
	        edit_width		= 13;} 
             spacer_1;
             spacer_1;
          }
	  spacer_1;
	}
        : column {
          : radio_row {
              key      = "box" ;
             : text {
                label                   = "title_box type: "; 
                fixed_height            = ture;
                width                   = 10;}
             : radio_button {
                label                   = "Width";
                key                     = "wid"; 
                alignment               = bottom;}
             : radio_button {
                label                   = "Length";
                key                     = "len";
                alignment               = bottom;}
          } 
        }        
	spacer_1;
	ok_cancel;
    }    
}
a000_2 :dialog{
    label                       = "a001";
    :column { 
      :row{
        : icon_image{
           key                  = "icon1";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon2";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon3";
           heith                = 8;
           width                = 15; } 
        : icon_image{
           key                  = "icon4";
           heith                = 8;
           width                = 15; }  }
     : row {
        : icon_image{
           key                  = "icon5";
           heith                = 8;
           width                = 15; } 
        : icon_image{
           key                  = "icon6";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon7";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon8";
           heith                = 8;
           width                = 15; }  }
     : row {
        : icon_image{
           key                  = "icon9";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon10";
           heith                = 8;
           width                = 15; } 
        : icon_image{
           key                  = "icon11";
           heith                = 8;
           width                = 15; }
        : icon_image{
           key                  = "icon12";
           heith                = 8;
           width                = 15; } }
      ok_cancel;  }
} 
a002 : dialog {
	label 				= "A002...leader text";
	: column {
             spacer_1;
	  : row {
	     : toggle {key = "s0";}
	     :edit_box{
		key = "i0";
		edit_width = 5;}
	     : toggle {key = "s1";}
	     :edit_box{
		key = "i1";
		edit_width = 5;}
	     : toggle {key = "s2";}
	     :edit_box{
		key = "i2";
		edit_width = 5;}
	     : toggle {key = "s3";}
	     :edit_box{
		key = "i3";
		edit_width = 5;}
	     : toggle {key = "s4";}
	     :edit_box{
		key = "i4";
		edit_width = 3;}
	     : toggle {key = "s5";}
	     :edit_box{
		key = "i5";
		edit_width = 2;}
	  }
	     : edit_box {
		fixed_width       	= true;
		key       		= "txt";
		edit_width		= 60;}
	     spacer_1;
	     ok_cancel;
}	}

a013 : dialog {
	label   			= "A013....pocket1";
	: row {
	  :column{
	      fixed_hight 		= true;
	    :boxed_column {
	      label     		= "Datas of Pocket_1: ";
	      fixed_hight 		= true;
	      spacer_0;
	      :row {
		:edit_box{
		  mnemonic 		= "e";
		  label 		= "Length =";
		  key 			= "l";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "+";
		  label 		= "+tol. =";
		  key 			= "l_p";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept = true;}
		:edit_box{
		  mnemonic 		= "-";
		  label 		= "-tol. =";
		  key 			= "l_m";
		  edit_width	 	= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
	      }
	      :row {
		:edit_box{
		  mnemonic 		= "W";
		  label 		= "Width =";
		  key 			= "w";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "t";
		  label 		= "+tol. =";
		  edit_width 		= 4;
		  key 			= "w_p";
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "o";
		  label 		= "-tol. =";
		  edit_width 		= 4;
		  key 			= "w_m";
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
	      }
	      :row {
		:edit_box{
		  mnemonic 		= "D";
		  label 		= "Depth =";
		  key 			= "d";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "l";
		  label 		= "+tol. =";
		  key 			= "d_p";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= ".";
		  label 		= "_tol. =";
		  key 			= "d_m";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
	      }
	      :row{
		:edit_box{
		  mnemonic 		= "X";
		  label 		= "Cen.X =";
		  key 			= "x_c";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "Y";
		  label 		= "Y =";
		  key 			= "y_c";
		  edit_width 		= 4;
		  horizontal_alignment 	= left;
		  allow_accept 		= true;}
		:edit_box{
		  mnemonic 		= "R";
		  label 		= "Corner R. =";
		  key 			= "cor";
		  edit_width 		= 2;
		  horizontal_alignment 	= right;
		  allow_accept 		= true;}
	      }
	    }  
	    :radio_row{
	      key 			= "p_j";
	      :radio_button{
		key 			= "ro";
		label 			= "Rough";}
	      :radio_button{
		key 			= "se";
		label 			= "Semi_finish";}
	      :radio_button{
		key 			= "fi";
		label 			= "Finish";}
	    }
	    : boxed_radio_row {
	       label 			= "Pocket Location:";
	       key		 	= "p_l";
	       :radio_button{
		 key 			= "up";
		 label 			= "Up";}
	       :radio_button{
		 key 			= "bo";
		 label 			= "Bottom";}
	       :radio_button{
		 key 			= "th";
		 label 			= "Through";}
	    }
	  }
	  :column {
	    : image_button{
	     color 			= 0;
	     key 			= "pocket1";
	     height 			= 8;
	     width 			= 30;}
	     ok_cancel;
}  }    }



a015 : dialog {
	 label 				= "A015....Q.M.K.";
      : row {
	: image_button{
		 color 			= 0;
		 key 			= "q";
		 height 		= 8;
		 width 			= 25;}   
	: column {
	  : edit_box{
	     mnemonic 			= "L";
	     label 			= "        Length = ";
	     key 			= "l";
	     edit_width 		= 5;
	     horizontal_alignment 	= left;
	     allow_accept 		= true;}
	  : edit_box{
	     mnemonic 			= "D";
	     label 			= "          Depth = ";
	     key 			= "d";
	     edit_width 		= 5;
	     horizontal_alignment 	= left;
	     allow_accept 		= true;}
	 : spacer {width = 3;}
	 ok_cancel;
     } }
}

a016 : dialog {
	 label 				= "A016....Pocket2";
       : column {
	: row {
	 : column {
	  : edit_box {
	     mnemonic 			= "D";
	     label 			= "             Diameter:";
	     key 			= "aj1";
	     edit_width 		= 20;
	     horizontal_alignment 	= left;
	     allow_accept 		= true;}
	  : edit_box{
	     mnemonic 			= "e";
	     label 			= "             Depth:";
	     key 			= "aj2";
	     edit_width 		= 20;
	     horizontal_alignment 	= left;
	     allow_accept 		= true;}
	  : edit_box{
	     mnemonic 			= "I";
	     label 			= "Is it has taper?(Y-\"1\"/N-\"0\"):";
	     key 			= "aj3";
	     edit_width 		= 10;
	     horizontal_alignment 	= left;
	     allow_accept 		= true;}
	}
	: image_button{
		 color 			= 0;
		 key 			= "pocket2";
		 height 		= 8;
		 width 			= 25;}   
     }
    : spacer {width = 3;}
    ok_cancel;
    }
}

dgml_3: dialog {
	label                   	= "A017....datas";
	 spacer_1;
	    : column {
	      : row {
		 fixed_width 		= true;
		 : popup_list {
		    mnemonic 		= "N" ;
		    list 		= "1\n4\n6";
		    key 		= "list_num" ;
		    label 		= "HoleQuti" ;
		    width 		= 3;
		    allow_accept 	= default;}
		 : popup_list {
		    list 		= "no offset\nleft offset\nright offset\nboth offset";
		    key 		= "list_ofs" ;
		    width 		= 10;
		    allow_accept 	= default;}
		 :edit_box{
		    edit_width 		= 6;
		    mnemonic 		= "f";
		    label 		= "OffsetDis.:";
		    key 		= "h_o";
		    horizontal_alignment = left;
		    allow_accept 	= true;}
	      }
	      : row {
		fixed_width 		= true; 
		 :edit_box{
		    mnemonic 		= "I";
		    label 		= "InsideDiameter:";
		    key 		= "dia";
		    edit_width 		= 6;
		    horizontal_alignment = left;
		    allow_accept 	= true;}
		 :edit_box{
		    mnemonic 		= "O";
		    label 		= "OutsideDiameter:";
		    key 		= "dia2";
		    edit_width 		= 6;
		    horizontal_alignment = left;
		    allow_accept 	= true;}
	      }
	      : row {
		fixed_width 		= true; 
		 :edit_box{
		    mnemonic 		= "D";
		    label 		= "ScrewsDia.";
		    key 		= "dia3";
		    edit_width 		= 6;
		    horizontal_alignment = left;
		    allow_accept 	= true;}
		 :edit_box{
		    mnemonic 		= "X";
		    label 		= "Cen. X:";
		    key 		= "c_x";
		    edit_width 		= 6;
		    horizontal_alignment = left;
		    allow_accept 	= true;}
		 :edit_box{
		    mnemonic 		= "Y";
		    label 		= "Y:";
		    key 		= "c_y";
		    edit_width 		= 6;
		    horizontal_alignment = left;
		    allow_accept 	= true;}
	      }
	   spacer_1;
	   ok_cancel;
	}
}


dgml_1: dialog {
	label                   	= "A017....hole type to select";
	:column {
		: row {
		    : icon_image {
			key         	= "icon0";}
		    : icon_image {
			key         	= "icon1";}
		    : icon_image {
			key         	= "icon2";}
		    : icon_image {
			key         	= "icon3";}
		}
		: row {
		    : icon_image {
			key         	= "icon4";}
		    : icon_image {
			key         	= "icon5";}
		    : icon_image {
			key         	= "icon6";}
		    : icon_image {
			key         	= "icon7";}
		}
		: row {
		    : icon_image {
			key         	= "icon8";}
		    : icon_image {
			key         	= "icon9";}
		    : icon_image {
			key         	= "icon10";}
		    : icon_image {
			key         	= "icon11";}
		}
		ok_cancel;
	}
}
