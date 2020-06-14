#name "test.cl"
#5 CLASS
#5 TYPEID CellularAutomaton
#5 INHERITS
#5 TYPEID IO
#5 '{'
#6 OBJECTID population_map
#6 ':'
#6 TYPEID String
#6 ';'
#8 OBJECTID init
#8 '('
#8 OBJECTID map
#8 ':'
#8 TYPEID String
#8 ')'
#8 ':'
#8 TYPEID SELF_TYPE
#8 '{'
#9 '{'
#10 OBJECTID population_map
#10 ASSIGN
#10 OBJECTID map
#10 ';'
#11 OBJECTID self
#11 ';'
#12 OBJECTID self
#12 '='
#12 BOOL_CONST true
#12 ';'
#13 '}'
#14 '}'
#14 ';'
#16 OBJECTID print
#16 '('
#16 ')'
#16 ':'
#16 TYPEID SELF_TYPE
#16 '{'
#17 '{'
#18 OBJECTID out_string
#18 '('
#18 OBJECTID population_map
#18 '.'
#18 OBJECTID concat
#18 '('
#18 STR_CONST "\n"
#18 ')'
#18 ')'
#18 ';'
#19 OBJECTID self
#19 ';'
#20 '}'
#21 '}'
#21 ';'
#23 OBJECTID num_cells
#23 '('
#23 ')'
#23 ':'
#23 TYPEID Int
#23 '{'
#24 OBJECTID population_map
#24 '.'
#24 OBJECTID length
#24 '('
#24 ')'
#25 '}'
#25 ';'
#27 OBJECTID cell
#27 '('
#27 OBJECTID position
#27 ':'
#27 TYPEID Int
#27 ')'
#27 ':'
#27 TYPEID String
#27 '{'
#28 OBJECTID population_map
#28 '.'
#28 OBJECTID substr
#28 '('
#28 OBJECTID position
#28 ','
#28 INT_CONST 1
#28 ')'
#29 '}'
#29 ';'
#31 OBJECTID cell_left_neighbor
#31 '('
#31 OBJECTID position
#31 ':'
#31 TYPEID Int
#31 ')'
#31 ':'
#31 TYPEID String
#31 '{'
#32 IF
#32 OBJECTID position
#32 '='
#32 INT_CONST 0
#32 THEN
#33 OBJECTID cell
#33 '('
#33 OBJECTID num_cells
#33 '('
#33 ')'
#33 '-'
#33 INT_CONST 1
#33 ')'
#34 ELSE
#35 OBJECTID cell
#35 '('
#35 OBJECTID position
#35 '-'
#35 INT_CONST 1
#35 ')'
#36 FI
#37 '}'
#37 ';'
#39 OBJECTID cell_right_neighbor
#39 '('
#39 OBJECTID position
#39 ':'
#39 TYPEID Int
#39 ')'
#39 ':'
#39 TYPEID String
#39 '{'
#40 IF
#40 OBJECTID position
#40 '='
#40 OBJECTID num_cells
#40 '('
#40 ')'
#40 '-'
#40 INT_CONST 1
#40 THEN
#41 OBJECTID cell
#41 '('
#41 INT_CONST 0
#41 ')'
#42 ELSE
#43 OBJECTID cell
#43 '('
#43 OBJECTID posit
#43 ERROR "`"
#43 OBJECTID ion
#43 '+'
#43 INT_CONST 1
#43 ')'
#44 FI
#45 '}'
#45 ';'
#49 OBJECTID cell_at_next_evolution
#49 '('
#49 OBJECTID position
#49 ':'
#49 TYPEID Int
#49 ')'
#49 ':'
#49 TYPEID String
#49 '{'
#50 IF
#50 '('
#50 IF
#50 OBJECTID cell
#50 '('
#50 OBJECTID position
#50 ')'
#50 '='
#50 STR_CONST "X"
#50 THEN
#50 INT_CONST 1
#50 ELSE
#50 INT_CONST 0
#50 FI
#51 '+'
#51 IF
#51 OBJECTID cell_left_neighbor
#51 '('
#51 OBJECTID position
#51 ')'
#51 '='
#51 STR_CONST "X"
#51 THEN
#51 INT_CONST 1
#51 ELSE
#51 INT_CONST 0
#51 FI
#52 '+'
#52 IF
#52 OBJECTID cell_right_neighbor
#52 '('
#52 OBJECTID position
#52 ')'
#52 '='
#52 STR_CONST "X"
#52 THEN
#52 INT_CONST 1
#52 ELSE
#52 INT_CONST 0
#52 FI
#53 '='
#53 INT_CONST 1
#53 ')'
#54 THEN
#55 STR_CONST "X"
#56 ELSE
#57 ERROR "'"
#57 '.'
#57 ERROR "'"
#58 FI
#59 '}'
#59 ';'
#61 OBJECTID evolve
#61 '('
#61 ')'
#61 ':'
#61 TYPEID SELF_TYPE
#61 '{'
#62 '('
#62 LET
#62 OBJECTID position
#62 ':'
#62 TYPEID Int
#62 IN
#63 '('
#63 LET
#63 OBJECTID num
#63 ':'
#63 TYPEID Int
#63 ASSIGN
#63 OBJECTID num_cells
#63 ERROR "["
#63 ERROR "]"
#63 IN
#64 '('
#64 LET
#64 OBJECTID temp
#64 ':'
#64 TYPEID String
#64 IN
#65 '{'
#66 WHILE
#66 OBJECTID position
#66 '<'
#66 OBJECTID num
#66 LOOP
#67 '{'
#68 OBJECTID temp
#68 ASSIGN
#68 OBJECTID temp
#68 '.'
#68 OBJECTID concat
#68 '('
#68 OBJECTID cell_at_next_evolution
#68 '('
#68 OBJECTID position
#68 ')'
#68 ')'
#68 ';'
#69 OBJECTID position
#69 ASSIGN
#69 OBJECTID position
#69 '+'
#69 INT_CONST 1
#69 ';'
#70 '}'
#71 POOL
#71 ';'
#72 OBJECTID population_map
#72 ASSIGN
#72 OBJECTID temp
#72 ';'
#73 OBJECTID self
#73 ';'
#74 '}'
#75 ')'
#75 ')'
#75 ')'
#76 '}'
#76 ';'
#77 '}'
#77 ';'
#79 CLASS
#79 TYPEID Main
#79 '{'
#80 OBJECTID cells
#80 ':'
#80 TYPEID CellularAutomaton
#80 ';'
#82 OBJECTID main
#82 '('
#82 ')'
#82 ':'
#82 TYPEID SELF_TYPE
#82 '{'
#83 '{'
#84 OBJECTID cells
#84 ASSIGN
#84 '('
#84 NEW
#84 TYPEID CellularAutomaton
#84 ')'
#84 '.'
#84 OBJECTID init
#84 '('
#84 STR_CONST "         X         "
#84 ')'
#84 ';'
#85 OBJECTID cells
#85 '.'
#85 OBJECTID print
#85 '('
#85 ')'
#85 ';'
#86 '('
#86 LET
#86 OBJECTID countdown
#86 ':'
#86 TYPEID Int
#86 ASSIGN
#86 INT_CONST 20
#86 IN
#87 WHILE
#87 OBJECTID countdown
#87 ERROR ">"
#87 INT_CONST 0
#87 LOOP
#88 '{'
#89 OBJECTID cells
#89 '.'
#89 OBJECTID evolve
#89 '('
#89 ')'
#89 ';'
#90 OBJECTID cells
#90 '.'
#90 OBJECTID print
#90 '('
#90 ')'
#90 ';'
#91 OBJECTID countdown
#91 ASSIGN
#91 OBJECTID countdown
#91 '-'
#91 INT_CONST 1
#91 ';'
#93 POOL
#94 ')'
#94 ';'
#99 ERROR "EOF in comment"
