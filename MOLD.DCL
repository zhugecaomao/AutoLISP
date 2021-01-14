mold1 : dialog {
    label     = "请选择模胚";
    spacer_0;
    : column {
     : row {
        : edit_box {
           label        ="订单号";
           key          ="order";
           alinment     =bottom;}
      }
     : radio_row {
        key         = "gate";
        : text {
            label       = "请选择模胚类型:";
            fix_height  = ture;
            width       = 15;}
        : radio_button {
            label       = "大水口";
            key         = "sgate";
            alignment   = bottom;}
        : radio_button {
	    label       = "细水口";
            key         = "ppgate";
            alignment   = bottom;}
        : radio_button {
            label       = "简化形细水口";
            key         = "tptype";
            alignment   = bottom;}
        } 
     : row {
        : edit_box {
           label        = "模胚基本板数:";
           key          = "plat_num";
           edit_width   = 5;
           fixed_width  = true;}
        : toggle {
           label        = "是否有中托钉?";
           key          = "egp_yn";
           fixed_width  = true;}
     }
     : row {
        : edit_box {
           label        = "托  司  组  数:";
           key          = "gp_num";
           width        = 2;
           fixed_width  = true;}
        : edit_box {
           label        = "直  司  组  数:";
           key          = "sgp_num";
           width        = 2;
           fixed_width  = true;}
     }
     : row {
        : edit_box {
           label        = "上模杯头组数:";
           key          = "tshcs_num";
           width        = 2;
           fixed_width  = true;}
        : edit_box {
           label        = "下模杯头组数:";
           key          = "bshcs_num";
           width        = 2;
           fixed_width  = true;}
     }
     : row {
        : button {
           label        = "模板";
           key          = "plat";
           fixed_width  = true;}
        : button {
           label        = "配件";
           key          = "part";
           fixed_width  = true;}
        ok_cancel;
     }
    }
}
mold2_1 : dialog {
     label       = "模板参数.....";
     : column {
       : row {
          : text {
             label          = "(1)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h1";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w1";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l1";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(2)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h2";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w2";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l2";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(3)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h3";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w3";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l3";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(4)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h4";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w4";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "宽长:";
             key            = "plat_l4";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(5)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h5";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w5";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l5";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(6)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h6";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w6";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l6";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(7)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h7";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w7";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l7";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(8)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h8";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w8";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l8";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(9)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h9";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w9";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l9";
             fixed_width    = true;
             edit_width     = 5;}
       }
    }
       : row {
          spacer_1;
          : button {
           label        = "配件";
           key          = "part";
           fixed_width  = true;}
          ok_only;
          spacer_1;
       }
 }

mold2_2 : dialog {
     label       = "模板参数.....";
     : column {
       : row {
          : text {
             label          = "(1)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h1";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w1";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l1";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(2)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h2";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w2";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l2";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(3)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h3";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w3";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l3";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(4)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h4";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w4";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l4";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(5)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h5";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w5";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l5";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(6)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h6";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w6";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l6";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(7)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h7";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w7";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l7";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(8)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h8";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w8";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l8";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(9)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h9";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w9";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l9";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(10)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h10";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w10";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l10";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(11)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h11";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w11";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l11";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(12)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h12";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w12";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l12";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(13)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h13";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w13";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l13";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(14)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h14";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w14";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l14";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          : text {
             label          = "(15)板的厚，宽，长:";
             fixed_width    = true;
             width          = 15;}
          : edit_box {
             label          = "板厚:";
             key            = "plat_h15";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板宽:";
             key            = "plat_w15";
             fixed_width    = true;
             edit_width     = 5;}
          : edit_box {
             label          = "板长:";
             key            = "plat_l15";
             fixed_width    = true;
             edit_width     = 5;}
       }
       : row {
          spacer_1;
          : button {
             label        = "配件";
             key          = "part";
             alignment    = centered;
             fixed_width  = true;}
          ok_only;
          spacer_1;
       }
    }
 }

mold3 : dialog {
  label          = "配件参数.....";
    : column {
      : row {
        : boxed_column {
          label        = "直     钉:";
          : edit_box {
             label        = "大小:";
             key          = "gb1_dia";
             edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "长度:";
             key          = "gb1_len";
 	     edit_width	  = 4;
             fixed_width  = true;}
          : edit_box  {
             label        = "板号:";
             key          = "gb1_plat";
             edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
            key          = "ina_b";
            : radio_button {
              label        = "直钉在上模";
              key          = "in_a";
              fixed_width  = true;}
            : radio_button {
              label        = "直钉在下模";
              key          = "in_b";
              fixed_width  = true;}
          }
        }
        : boxed_column {
          label        = "水   口   边:";
          : edit_box {
             label       = "大小:";
             key         = "sp_dia";
             edit_width	  = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "长度:";
             key          = "sp_len";
 	     edit_width	  = 4;
             fixed_width  = true;}
          : edit_box  {
             label        = "板号:";
             key          = "sp_plat";
             edit_width   = 4;
             fixed_width  = true;}
        }
        : boxed_column {
          label        = "第一组托司";
          : edit_box  {
             label        = "大小:";
             key          = "gp1_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "gp1_len";
	     edit_width	  = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "gp1_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "gp1_drct";
             : radio_button {
                label        = "向上";
                key          = "gp1_t";
                fixed_width  = true;}
             : radio_button {
                label        = "向下";
                key          = "gp1_b";
                fixed_width  = true;}
          }
        }
        : boxed_column {
          label        = "第二组托司";
          : edit_box  {
             label        = "大小:";
             key          = "gp2_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "gp2_len";
 	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "gp2_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "gp2_drct";
             : radio_button {
                label        = "向上";
                key          = "gp2_t";
                fixed_width  = true;}
             : radio_button {
                label        = "向下";
                key          = "gp2_b";
                fixed_width  = true;}
          }
        }
        : boxed_column {
          label        = "第一组直司";
          : edit_box  {
             label        = "大小:";
             key          = "sgp1_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "sgp1_len";
 	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "sgp1_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "sgp1_com";
             : radio_button {
                label        = "配直钉";
                key          = "in_gb1";
                fixed_width  = true;}
             : radio_button {
                label        = "配水口边";
                key          = "in_sp1";
                fixed_width  = true;}
          } 
        }
      }
      : row {
        : boxed_column {
          label        = "第二组直司";
          : edit_box  {
             label        = "大小:";
             key          = "sgp2_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "sgp2_len";
 	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "sgp2_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "sgp2_com";
             : radio_button {
                label        = "配直钉";
                key          = "in_gb2";
                fixed_width  = true;}
             : radio_button {
                label        = "配水口边";
                key          = "in_sp2";
                fixed_width  = true;}
          } 
        }
        : boxed_column {
          label        = "第三组直司";
          : edit_box  {
             label        = "大小:";
             key          = "sgp3_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "sgp3_len";
 	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "sgp3_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "sgp3_com";
             : radio_button {
                label        = "配直钉";
                key          = "in_gb3";
                fixed_width  = true;}
             : radio_button {
                label        = "配水口边";
                key          = "in_sp3";
                fixed_width  = true;}
          } 
        }
        : boxed_column {
          label        = "第四组直司";
          : edit_box  {
             label        = "大小:";
             key          = "sgp4_dia";
	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box  { 
             label        = "长度:";
             key          = "sgp4_len";
 	     edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "板号:";
             key          = "sgp4_plat";
 	     edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "sgp4_com";
             : radio_button {
                label        = "配直钉";
                key          = "in_gb4";
                fixed_width  = true;}
             : radio_button {
                label        = "配水口边";
                key          = "in_sp4";
                fixed_width  = true;}
          } 
        }
        : boxed_column {
          label         = "中  托  钉";
          : edit_box {
             label        = "大小:";
             key          = "egp_dia";
             edit_width   = 4;
             fixed_width  = true;}
          : edit_box {
             label        = "长度:";
             key          = "egp_len";
             edit_width   = 4;
             fixed_width  = true;}
          : radio_column {
             key          = "egp_drct";
             : text {
                label        = "中托司介子头:";
                fixed_width  = true;}
             : radio_button {
                label        = "在面针板";
                key          = "in_ejrp";
                fixed_width  = true;}
             : radio_button {
                label        = "在度针板";
                key          = "in_ejp";
                fixed_width  = true;}
          } 
        }
        : boxed_column {
          label        = "回     针";
          spacer_1;
          : edit_box {
             label        = "大小:";
             key          = "rp_dia";
             edit_width   = 4;
             fixed_width  = true;}
          spacer_1;
          : edit_box {
             label        = "长度:";
             key          = "rp_len";
             edit_width   = 4;
             fixed_width  = true;}
          spacer_1;
        }
      } 
    : row {     
      : boxed_column {
        label      = "上模杯头螺丝....";
        : row {
           : edit_box {
              label        = "第一组大小:";
              key          = "tshcs1_dia";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "长度:";
              key          = "tshcs1_len";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "板号:";
              key          = "tshcs1_plat";
              edit_width   = 1;
              fixed_width  = true;}
         }
         : row {
           : edit_box {
              label        = "第二组大小:";
              key          = "tshcs2_dia";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "长度:";
              key          = "tshcs2_len";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "板号:";
              key          = "tshcs2_plat";
              edit_width   = 1;
              fixed_width  = true;}
         }
       }
       : boxed_column {
         label      = "下模杯头螺丝....";
         : row {
           : edit_box {
              label        = "第一组大小:";
              key          = "bshcs1_dia";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "长度:";
              key          = "bshcs1_len";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "板号:";
              key          = "bshcs1_plat";
              edit_width   = 1;
              fixed_width  = true;}
         }
         : row {
           : edit_box {
              label        = "第二组大小:";
              key          = "bshcs2_dia";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "长度:";
              key          = "bshcs2_len";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "板号:";
              key          = "bshcs2_plat";
              edit_width   = 1;
              fixed_width  = true;}
         }
         : row {
           : edit_box {
              label        = "第三组大小:";
              key          = "bshcs3_dia";
              edit_width   = 4;
              fixed_width  = true;}
           : edit_box {
              label        = "长度:";
              key          = "bshcs3_len";
              edit_width   = 4;
              fixed_width  = true;}
         }
      }
     }
     : row {
          spacer_1;
        : button {
           label        = "模板";
           key          = "plat";
           alignment    = centered;
           fixed_width  = true;}
        ok_only;
          spacer_1;
     }   
}  }
        