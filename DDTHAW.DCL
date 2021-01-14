// THAW.DCL

//DDTHAW.LSP的对话框
ddthaw : dialog {
  label = " 解冻层 " ;
  : list_box {
    key = "lyrlist" ;
    label = " 冻结的层： " ;
    multiple_select = true;
  }
  ok_cancel;
}
