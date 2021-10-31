;;---------------------------------------------------------------------

;;Peter Bergeon - peterbergeon@csu.fullerton.edu
;;Brian Edwards - brian_edwards@csu.fullerton.edu
;;Desirae Prather - desiraeprather@csu.fullerton.edu
;;Ryan Romero - rromero26@csu.fullerton.edu

;;Project 1 - Card Sorting Planner

;;Group Name: RPDB

;;Class: CPSC 481-01

;;Description: This Lisp program  allows you to come up with a plan to adjust 5-7 distinct cards in 3 rows
;;so that they are all in the first row and sorted in "descending" order.

;;---------------------------------------------------------------------



;;---------------------------------------------------------------------
;; Function: heuristic
;; Description: Calculates and assigns a heuristic value to the node

(defun heuristic (mom)
(setq h 0)
(setq sorted '())
(dotimes (n1 (length mom))
(setq sorted (append (nth n1 mom) sorted)))
(setq sorted (sort sorted  #'string<))
(dotimes (n2 (- (length mom) 1))
    (dotimes (j (length (nth (+ n2 1) mom)))
         (setq h (+ h j 1))))
(setq i 2)
(dotimes (n3 (length (car mom)))
	(if (equal (nth n3 (reverse (car mom))) (car sorted))
	    (pop sorted) (progn (setq h (+ h i)) (setq i (+ i 1)))))
h)
;;--------------------------------------------------------------------------------
;; Function: generate-children
;; Description: Given a node in the parameter, generate its children and return it

(defun generate-children (mom)
(setq children '())
(setq child '())
(dotimes (first (length mom))
   (dotimes (second first)
   	    (setq value1 (nth first mom))
	    (setq value2 (nth second mom))
      (if (not (equal value1 value2))
      (progn (if (and (or (string> (car value1) (car value2)) (not value2)) value1)
	(push (pop value1) value2)
	(push (pop value2) value1))
	(dotimes (toadd (length mom))
	   (if (equal toadd first) (push value1 child))
	   (if (equal toadd second) (push value2 child))
	   (if (not (or (equal toadd first) (equal toadd second)))
	       (push (nth toadd mom) child) child))
	(push (reverse child) children)
	(setq child '())))))
children)
;;----------------------------------------------------------------------------------------
;;Function: project1
;;Description: Synonymous to a main function. Runs the whole project utilizing the other functions defined
(defun project1 (start)
       (setf index 1)
       (setf limiter 1)
       (setf open '())
       (setf closed '())
       (setf open (append open (list (fix start nil index 0))))
       (while (and (> (length open) 0) (not (equal (cadr (member :h (car open))) 0)) (< limiter 2000)) 
       	      (setf current (pop open))
	      (setf children (generate-children (cadr (member :state current))))
	      (while (> (length children) 0) 
	      	     (setf child (pop children))
		     (if (not (or (find-state open child)
		     	      	  (find-state closed child)))
		        (progn
			   (setf open (append open (list (fix child
			   (cadr (member :id current))
			   (+ index 1)
			   (+ 1 (cadr (member :f current)))))))
			   (setf index (+ index 1)))


			   (if (find-state open child)
;; Both of the below sorts sort a specific id node to the front of either open or closed list so We ;;can pop it out of the list and reinsert a version with the correct mom 
			    (progn
			       (setf child (find-state open child))
			       (setq idd (cadr (member :id child)))
			       (setq open (sort open #'(lambda (x y)
                       	       	     	   (<= (abs (- (cadr (member :id x)) idd))
                           		   (abs (- (cadr (member :id y)) idd))))))
			       (setf child (list (fixmom (pop open) current)))
			       (setf open (append open child)))
    (progn
			       (setf child (find-state closed child))
			       (setq idd (cadr (member :id child)))
			       (setq closed (sort closed #'(lambda (x y)
                       	       	     	   (<= (abs (- (cadr (member :id x)) idd))
                           		   (abs (- (cadr (member :id y)) idd))))))
			       (setf child (list (fixmom (pop closed) current)))
			       (setf closed (append closed child))))
			   ))
	      (setq open (sort open #'(lambda (x y) ;which node to expand next
                       	       	     	   (<= (+ (* 3 (cadr (member :h x))) (cadr (member :f x)))
                           		   (+ (* 3 (cadr (member :h y))) (cadr (member :f y)))))))
	      (setf closed (append closed (list current)))
	      (setf limiter (+ limiter 1))
	      ;(print (append (list 'OPEN) open)) (print closed)
	      )
	(setf closed (append closed (list (car open))))
	(setf closed (sort closed #'(lambda (x y)
                       	       	     	   (<= (cadr (member :h x))
                           		   (cadr (member :h y))))))
	(printpath (car closed) closed))
;;-------------------------------------------------------------------------------------
;;Function: printpath
;;Description: Given a node and the closed list, return its path to start
(defun printpath (curr closed)
       	    (if (cadr (member :mom curr))
	    	(printpath (find-id closed (cadr (member :mom curr))) closed))
	    (prin1 curr)
	    (terpri)
	    'GOAL_FOUND)
;;-------------------------------------------------------------------------------------
;;Function: find-id
;;Description: Given an id, return the node with that id
(defun find-id (tosearch id)
       (setf toret 0)
       	    (dolist (n tosearch)
	    	    (if (equal id (cadr (member :id n)))
		    	(setf toret n)))
	toret)
;;-------------------------------------------------------------------------------------
;;Function: fix
;;Description: Given a node, a mom node, an id, and a f value, create and return  a list that includes all of them in the form of slots.
(defun fix (state mom id f)
       (setq ret (append
       (list :id)
       (list id)
       (list :mom)
       (list mom)
       (list :h)
       (list (heuristic state))
       (list :state)
       (list state)
       (list :f)
       (list f)))
       ret)   
;;-------------------------------------------------------------------------------------
;;Function: find-state
;;Description: Given a list and a state node, find the given state from the list and return it
(defun find-state(thelist state)
       (setq ret nil)
       (dolist (n thelist)
       		 (if (equal state (cadr (member :state n)))
		     (setq ret n)))   
       ret)
;;-------------------------------------------------------------------------------------
;;Function: fixmom
;;Description: Given a child node and "new mom" node, replace the child's current mom node information with the new mom's
(defun fixmom (child newmom)
   (setq ret child)
   (if (< (cadr (member :f newmom)) (- (cadr (member :f child)) 1))
      (progn (setq ret (fix
         (cadr (member :state child))
	 (cadr (member :id newmom))
	 (cadr (member :id child))
	 (+ 1 (cadr (member :f newmom)))))
	 ))
	 ret)
;;-------------------------------------------------------------------------------------