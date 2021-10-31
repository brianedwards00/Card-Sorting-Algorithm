Project-1 Card Sorting Read Me

Class Number: 	CPSC481-01
Project Name: 	Card Sorting Planner (Project 1)
Team Name: 		RPBD
Team Members:
●	Ryan Romero
●	Peter Bergeon
●	Brian Edwards
●	Desirae Prather
Intro:
This Lisp program, when given an assortment of “cards” in 3 different rows, comes up with the shortest move actions to get all the “cards” in the first row and sorted in "descending" order.
Only 1 card can be moved during any move action and the cards must stay sorted in descending order at all times within their respective row. To do this, we use State Space Search
and a Heuristic Function to find the shortest path to the goal state. Once the shortest path is found, we can print out the move actions we need to take in order to reach the goal state.
	The algorithm used in this project is the Best first search. The specifics about this algorithm can be found in the Features section below where it mentions “heuristic”.
  
Contents (files in zip):
●	project1.el
●	README.txt

External Requirements:
	None, the code should be able to run on any EMACS text editor. We test ran our elisp file on Tuffix and on Windows OS using the GNU emacs editor using the up-to-date versions.

Setup/Installation:
-	We are assuming that you already have the GNU emacs editor installed. Follow the steps below to execute the project file.

1)	Download the zip folder 
2)	Extract the contents on any desired location.
3)	Open Emacs
4)	Click on “Open file”
5)	Find and open project1.el file in the unzipped folder
6)	Execute every function in the file to load it to the buffer. To do so:
	a)	Go to the last parentheses of each function
			(For your convenience, functions are separated by a comment filled with dash(-) characters; go to line just above each dash-filled comment after the closing parenthesis)
	b)	Press Ctrl + x then Ctrl+e.
	c)	Repeat this process until all functions have complied
	OR
	a)	Use M-x ev-r after having highlighted the entire project
7)	Go to the end of the function and type in a call to project1
a)	Example: (project1 '((C A) (E B) (D))) 
b)	press Ctrl + x then Ctrl+e
c)	Feel free to change the letters and orders within to test the project

Sample Invocation:
	Input:
(project1 '((A) (F E D C B) nil))
Output:
(:id 1 :mom nil :h 15 :state ((A) (F E D C B) nil) :f 0)
(:id 4 :mom 1 :h 12 :state ((F A) (E D C B) nil) :f 1)
(:id 25 :mom 4 :h 9 :state ((F A) (D C B) (E)) :f 2)
(:id 26 :mom 25 :h 9 :state ((A) (D C B) (F E)) :f 3)
(:id 28 :mom 26 :h 8 :state ((D A) (C B) (F E)) :f 4)
(:id 29 :mom 28 :h 9 :state ((D A) (F C B) (E)) :f 5)
(:id 32 :mom 29 :h 11 :state ((E D A) (F C B) nil) :f 6)
(:id 36 :mom 32 :h 12 :state ((F E D A) (C B) nil) :f 7)
(:id 39 :mom 36 :h 11 :state ((F E D A) (B) (C)) :f 8)
(:id 40 :mom 39 :h 9 :state ((E D A) (B) (F C)) :f 9)
(:id 45 :mom 40 :h 8 :state ((D A) (E B) (F C)) :f 10)
(:id 46 :mom 45 :h 9 :state ((D A) (F E B) (C)) :f 11)
(:id 48 :mom 46 :h 9 :state ((A) (F E B) (D C)) :f 12)
(:id 54 :mom 48 :h 8 :state ((F A) (E B) (D C)) :f 13)
(:id 55 :mom 54 :h 9 :state ((F A) (B) (E D C)) :f 14)
(:id 62 :mom 55 :h 11 :state ((A) (B) (F E D C)) :f 15)
(:id 83 :mom 62 :h 10 :state ((B A) nil (F E D C)) :f 16)
(:id 84 :mom 83 :h 7 :state ((B A) (F) (E D C)) :f 17)
(:id 86 :mom 84 :h 6 :state ((E B A) (F) (D C)) :f 18)
(:id 88 :mom 86 :h 8 :state ((F E B A) nil (D C)) :f 19)
(:id 97 :mom 88 :h 7 :state ((F E B A) (D) (C)) :f 20)
(:id 98 :mom 97 :h 6 :state ((E B A) (D) (F C)) :f 21)
(:id 101 :mom 98 :h 6 :state ((B A) (E D) (F C)) :f 22)
(:id 102 :mom 101 :h 7 :state ((B A) (F E D) (C)) :f 23)
(:id 107 :mom 102 :h 6 :state ((C B A) (F E D) nil) :f 24)
(:id 109 :mom 107 :h 5 :state ((F C B A) (E D) nil) :f 25)
(:id 113 :mom 109 :h 4 :state ((F C B A) (D) (E)) :f 26)
(:id 114 :mom 113 :h 4 :state ((C B A) (D) (F E)) :f 27)
(:id 116 :mom 114 :h 3 :state ((D C B A) nil (F E)) :f 28)
(:id 117 :mom 116 :h 2 :state ((D C B A) (F) (E)) :f 29)
(:id 119 :mom 117 :h 1 :state ((E D C B A) (F) nil) :f 30)
(:id 121 :mom 119 :h 0 :state ((F E D C B A) nil nil) :f 31)
GOAL_FOUND
Mark set
Features:
-	Uses proper for loops (dotimes (n i) … ) So that the main project function works for any number of elements and any number of rows.
	The only stipulations are that the elements are sortable using string>, and that the lowest element is in the rightmost colum
	(this is because of how the heuristic function works and that we don’t bother checking which row the lowest value is in).

-	The generate-children function looks at all possible unique pairs of columns, so with 3 rows we have (1,2) (2,3) (1,3), and decides which one has a greater value on top (car)
	and using that to generate 1 child. It then returns all the children in a list.
-	Use an f value to represent how many steps away from the starting condition a node is. This is predominately used when expanding to a node that already exists in the open node list.
	When this happens, we compare whether this new mom or the old mom is closer to start and replace that for the node visited.
-	When determining which node on the open list to expand to next, we first prioritize comparing heuristic values, and for tie breakers we use the f value.
	So a (h,f) of (5,10) will be checked before (6,5) will be checked before (6, 10) etc.
-	A few helper functions are also defined, which aids the more complex functions mentioned above. Most of the function names are self-explanatory.
	For all of the functions though, explanations of what they do specifically are written as comments in the code at your convenience.
	-	printpath
	-	find-id
	-	fix
	-	find-state
	-	fixmom
Bugs:
There are currently no known bugs.
If there are any errors, it may either be because you have a very old version of emacs or the code was executed incorrectly in the buffer (see setup instructions above).

Reference Links:
-	LISP Tutorial (tutorialspoint.com)
