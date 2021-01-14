; texth-ch.Lsp
; 修改字高
; Jun 25th 2001

; ent ent_data ent_lay_new ent_lay_name ent_list ent_list_len
; id ent_lay_old ent_data_new msg1 msg2

(defun c:llsp()
  (load "tch")
)

(defun c:tch(/ orig_blip orig_cmd ent nt_data ent_lt_new 
		    ent_list ent_list_len id ent_lt_old
		    ent_data_new msg1 msg2)
  (setq orig_blip (getvar "blipmode"))
  (setq orig_cmd (getvar "cmdecho"))
  (setvar "blipmode" 0 )
  (setvar "cmdecho" 0 )

 (setq ent (entsel "\n 请选取要修改成字高的字："))

  (setq ent_data (entget (car ent)))
  (setq ent_lt_new (assoc 40 ent_data))

  (prompt "\n 请选取欲修改的字： ")
  (setq ent_list (ssget))   ;选取一个修改的区域,包含无数对象
  (setq ent_list_len (sslength ent_list))；计算区域中符合要求的对象的数目
  (setq id 0)
  (repeat ent_list_len
    (setq ent_data (entget (ssname ent_list id)))  ;对象集中取出一个对象
    (setq ent_lt_old (assoc 40 ent_data))  ;把图元的字高值赋给一个数
    (setq ent_data_new (subst ent_lt_new ent_lt_old ent_data))；修改图元字高
    (entmod ent_data_new)
    (setq id (1+ id))
   ) ; end of repeat

  (setq msg1 "\n 已将选取的字改变了字高 ")
  (setq msg2 " 。")
  (setq msg1 (strcat msg1 msg2))
  (prompt msg1)

  (setvar "blipmode" orig_blip)
  (setvar "cmdecho" orig_cmd)
  (prin1)
 ); end of Tch

	(setq msg_ "\n .........Command: tch .........\n")
	(prompt msg_)