bil_1: dialog {
	label                   	= "bil.....bil type select.";
	:column {
      		: row {
                spacer_1;
		    : icon_image {
			key         	= "icon1";
                        heith           = 10;
                        width           = 25;}
                spacer_1;
		    : icon_image {
			key         	= "icon2";
                        heith           = 10;
                        width           = 25;}
		spacer_1;     
                }
                : row {
                spacer_1;
		    : icon_image {
			key         	= "icon3";
                        heith           = 10;
                        width           = 25;}
                spacer_1;
		    : icon_image {
			key         	= "icon4";
                        heith           = 10;
                        width           = 25;}
                spacer_1;
                     }
		ok_cancel;
	   }
     }

bil_2: dialog {
     label                         = "bil........the bil datas";
     :row {
       :column {
              :edit_box{
                label                = "Z.K X lenth(L)";
                key                  = "zk_l";
                edit_width           = 6;
                horizontal_alignment = right;
                allow_acept          = ture;}
              :edit_box{
                label                = "Z.K Y lenth(W)";
                key                  = "zk_w";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;}
              :edit_box{
                label                = "Z.K degree(DG)";
                key                  = "zk_g";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;}
              :edit_box{
                label                = "Z.K depth(DP)";
                key                  = "zk_p";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;}
              :edit_box{
                label                = "Z.K    (DR)";
                key                  = "zk_r";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;} 
              :row{  
                  :radio_column{
                        key              = "s";
                        :radio_button{
                              key                  = "s1";}
                        :radio_button{
                              key                  = "s2";}
                           }
                  :column{     
                      :edit_box{
                          key                  = "zk_k";
                          label                = "ZK...(kk)";
                          edit_width           = 6;
                          horizontal_alignment = left;
                          allow_acept          = ture;}
                      :edit_box{
                          key                  = "zk_l1";
                          label                = "ZK...(kL)";
                          edit_width           = 6;
                          horizontal_alignment = left;
                          allow_acept          = ture;}
                      }
                   }
               }
       spacer_1;
       :column { 
              :image{
                color                = 0;
                key                  = "zkicon";
                height               = 9;
                width                = 20;}
              :edit_box{
                label                = "drawing AO Z.K layer";
                key                  = "lay1";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;}
              :edit_box{
                label                = "drawing TU Z.K layer";
                key                  = "lay2";
                edit_width           = 6;
                horizontal_alignment = left;
                allow_acept          = ture;}
              }
        }
      ok_cancel;
}
              