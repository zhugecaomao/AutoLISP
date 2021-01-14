sta :dialog{
  label      = "标准模胚";
  spacer_0;
  : column {
     : row {
        : edit_box {
           label        ="订单号";
           key          ="order";
           alinment     =bottom;}
      }
     : row {
       : edit_box {
           label        = "型号:";
           key          = "type_p";
           edit_width   = 3;
           fixed_width  = true;}
        : edit_box {
           key          = "msize";
           edit_width   = 5;
           fixed_width  = true;}
        : edit_box {
           label        = "A:";
           key          = "apd";
           edit_width   = 3;
           fixed_width  = true;}
        : edit_box {
           label        = "B:";
           key          = "bpd";
           edit_width   = 3;
           fixed_width  = true;}
        : edit_box {
           label        = "S/Y:";
           key          = "s_y";
           edit_width   = 1;
           fixed_width  = true;}
        : edit_box {
           label        = "O/I:";
           key          = "o_i";
           edit_width   = 1;
           fixed_width  = true;}
      }
     : boxed_radio_row {
        key         = "egy_n";
        : text {
            label       = "标准位置加中托钉/司:";
            fix_height  = ture;
            width       = 15;}
        : radio_button {
            label       = "否";
            key         = "N";
            alignment   = bottom;}
        : radio_button {
	    label       = "是";
            key         = "Y";
            alignment   = bottom;}
        } 
      ok_cancel;
  } }
        