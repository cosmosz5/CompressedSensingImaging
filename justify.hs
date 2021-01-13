import Data.List
import Data.Char

text1 = "He who controls the past controls the future. He who controls the present controls the past."
text2 = "A creative man is motivated by the desire to achieve, not by the desire to beat others."


-- ========================================================================================================================== --







-- ========================================================= PART 1 ========================================================= --


--
-- Define a function that splits a list of words into two lists, such that the first list does not exceed a given line width.
-- The function should take an integer and a list of words as input, and return a pair of lists.
-- Make sure that spaces between words are counted in the line width.
--
-- Example:
--    splitLine ["A", "creative", "man"] 12   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 11   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 10   ==>   (["A", "creative"], ["man"])
--    splitLine ["A", "creative", "man"] 9    ==>   (["A"], ["creative", "man"])
--


splitLine :: [String] -> Int -> ([String], [String])
-- Function definition here

splitLine' (x:xs) n
            | n >= length(x) = [x]:splitLine' (xs) (n-length(x)-1)
            | otherwise = take 100 [x:xs]
splitLine (x:xs) n 
         |  n < length(concat(x:xs))+length(x:xs)-1 = (concat (init (splitLine' (x:xs) n)), last (splitLine' (x:xs) n))
         |  n >= length(concat(x:xs)) = ((x:xs),[""])

-- ========================================================= PART 2 ========================================================= --


--
-- To be able to align the lines nicely. we have to be able to hyphenate long words. Although there are rules for hyphenation
-- for each language, we will take a simpler approach here and assume that there is a list of words and their proper hyphenation.
-- For example:

enHyp = [("creative", ["cr","ea","ti","ve"]), ("controls", ["co","nt","ro","ls"]), ("achieve", ["ach","ie","ve"]), ("future", ["fu","tu","re"]), ("present", ["pre","se","nt"]), ("motivated", ["mot","iv","at","ed"]), ("desire", ["de","si","re"]), ("others", ["ot","he","rs"])]


--
-- Define a function that splits a list of words into two lists in different ways. The first list should not exceed a given
-- line width, and may include a hyphenated part of a word at the end. You can use the splitLine function and then attempt
-- to breakup the next word with a given list of hyphenation rules. Include a breakup option in the output only if the line
-- width constraint is satisfied.
-- The function should take a hyphenation map, an integer line width and a list of words as input. Return pairs of lists as
-- in part 1.
--
-- Example:
--    lineBreaks enHyp 12 ["He", "who", "controls."]   ==>   [(["He","who"], ["controls."]), (["He","who","co-"], ["ntrols."]), (["He","who","cont-"], ["rols."])]
--
-- Make sure that words from the list are hyphenated even when they have a trailing punctuation (e.g. "controls.")
--
-- You might find 'map', 'find', 'isAlpha' and 'filter' useful.
--


lineBreaks :: [(String, [String])] -> Int -> [String] -> [([String], [String])]
-- Function definition here

-- finding possible hyphenation
map' f n (x) =  lookup (period(concat [head (snd (splitLine (x) n))])) f
                     where period x | x == [] = []
                                    | last x == '.' =  init x
                                    | last x == ',' =  init x 
                                    | otherwise = x

-- taking first two a nd rest as pair
hyph f n x = ((concat (take 2 (a (map' f n x))))++"-", concat (drop 2 (a (map' f n x))))
                                             where a (Just aa) = aa
                                                   a Nothing = []
                                                   ad (a,b) = (a++"-" , b) 
-- taking only first and rest as pair
hyph1 f n x = ((concat (take 1 (a (map' f n x))))++"-", concat (drop 1 (a (map' f n x))))
                                             where a (Just aa) = aa
                                                   a Nothing = []
                                                   ad (a,b) = (a++"-" , b) 
-- -- taking first three and rest as pair
hyph3 f n x = ((concat (take 3 (a (map' f n x))))++"-", concat (drop 3 (a (map' f n x))))
                                             where a (Just aa) = aa
                                                   a Nothing = []
                                                   ad (a,b) = (a++"-" , b) 

-- adding to pairs 
join f n x = [(fst (splitLine x n) ++ [fst (hyph f n x)] , [snd (hyph f n x)] ++ left (snd (splitLine x n)))] 
                                                                            where left (x:xs) | xs == [] = []
                                                                                              | otherwise = xs


join1 f n x = [(fst (splitLine x n) ++ [fst (hyph1 f n x)] , [snd (hyph1 f n x)] ++ left (snd (splitLine x n)))] 
                                                                            where left (x:xs) | xs == [] = []
                                                                                              | otherwise = xs

join3 f n x =  [(fst (splitLine x n) ++ [fst (hyph3 f n x)] , [snd (hyph3 f n x)] ++ left (snd (splitLine x n)))] 
                                                                            where left (x:xs) | xs == [] = []
                                                                                              | otherwise = xs

-- filtering whichever fits in line width
lineBreaks f n (x) | iff =  filter (\x -> length (concat(fst x))+length(fst x)-1 <= n) (splitLine (x) n : join1 f n (x) ++ join f n (x) ++ join3 f n (x))
                   | ifff = [((x),[""])]
                   | otherwise = [splitLine x n]
    
 where iff = n < length(concat(x))+length(x)-1  && map' f n x /= Nothing
       ifff = n >= length(concat(x)) && map' f n x /= Nothing



-- ========================================================= PART 3 ========================================================= --


--
-- Define a function that inserts a given number of blanks (spaces) into a list of strings and outputs a list of all possible
-- insertions. Only insert blanks between strings and not at the beginning or end of the list (if there are less than two
-- strings in the list then return nothing). Remove duplicate lists from the output.
-- The function should take the number of blanks and the the list of strings as input and return a lists of strings.
--

-- Example:
--    blankInsertions 2 ["A", "creative", "man"]   ==>   [["A", " ", " ", "creative", "man"], ["A", " ", "creative", " ", "man"], ["A", "creative", " ", " ", "man"]]
--
-- Use let/in/where to make the code readable
--


blankInsertions :: Int -> [String] -> [[String]]
-- Function definition here


blank_insert _ [] = []
blank_insert n (x:xs) | n>0 = x:[" "] ++ blank_insert (n-1) xs
           | otherwise = x:xs

-- permuting and filtering the desired possibilities
blankInsertions n y = dupli (filter (condotions) (permutations (blank_insert n y)))
                      where dupli [] = []
                            dupli (x:xs) = x : dupli (filter (/=x)xs)
                            condotions = \x-> last x /= " " && head x /= " " && last x == last y && head x ==head y

-- ========================================================= PART 4 ========================================================= --


--
-- Define a function to score a list of strings based on four factors:
--
--    blankCost: The cost of introducing each blank in the list
--    blankProxCost: The cost of having blanks close to each other
--    blankUnevenCost: The cost of having blanks spread unevenly
--    hypCost: The cost of hyphenating the last word in the list
--
-- The cost of a list of strings is computed simply as the weighted sum of the individual costs. The blankProxCost weight equals
-- the length of the list minus the average distance between blanks (0 if there are no blanks). The blankUnevenCost weight is
-- the variance of the distances between blanks.
--
-- The function should take a list of strings and return the line cost as a double
--
-- Example:
--    lineCost ["He", " ", " ", "who", "controls"]
--        ==>   blankCost * 2.0 + blankProxCost * (5 - average(1, 0, 2)) + blankUnevenCost * variance(1, 0, 2) + hypCost * 0.0
--        ==>   blankCost * 2.0 + blankProxCost * 4.0 + blankUnevenCost * 0.666...
--
-- Use let/in/where to make the code readable
--


---- Do not modify these in the submission ----
blankCost = 1.0
blankProxCost = 1.0
blankUnevenCost = 1.0
hypCost = 1.0
-----------------------------------------------


lineCost :: [String] -> Double
-- Function definition here

hyp x 
  | last (last x) == '-' = 1.0
  | otherwise = 0.0

intblank [] = 0.0
intblank (x:xs)
  |  x == " " = 1.0  + intblank xs
  |  otherwise = 0.0  + intblank xs

average [a,b,c] = (a+b+c) / 3

-- need for variance
summedElements y = sum (map (\x -> (x - average input) ^ 2) input) 
                                      
                                      where input = val_for_avg_var y
variance x = (sqrt (summedElements x / 3)) ^ 2

val_for_avg_var x = [a x, b x, c x]
       where 
        a [] = 0
        a (x:xs) | x==" " = 0
                 | otherwise = 1 + a xs
        b [] = 0
        b (x:xs) | x == " " = a xs 
                 | otherwise = b xs
        c [] = 0
        c x = a (reverse x)


blankprox x | ifblank x =   realToFrac (length x) - average (val_for_avg_var x)
            | otherwise = 0.0
            where ifblank [] = False
                  ifblank (x:xs) | x == " " = True || ifblank xs
                                 | otherwise = False || ifblank xs 

-- summing all cost
lineCost x = blankCost * intblank x + blankProxCost * blankprox x + blankUnevenCost * variance x + hypCost * hyp x



-- ========================================================= PART 5 ========================================================= --


--
-- Define a function that returns the best line break in a list of words given a cost function, a hyphenation map and the maximum
-- line width (the best line break is the one that minimizes the line cost of the broken list).
-- The function should take a cost function, a hyphenation map, the maximum line width and the list of strings to split and return
-- a pair of lists of strings as in part 1.
--
-- Example:
--    bestLineBreak lineCost enHyp 12 ["He", "who", "controls"]   ==>   (["He", "who", "cont-"], ["rols"])
--
-- Use let/in/where to make the code readable
--


bestLineBreak :: ([String] -> Double) -> [(String, [String])] -> Int -> [String] -> ([String], [String])
-- Function definition here

bestLineBreak f ff n x  = head (filter (\y -> lineCost (fst y) ==mini) (reverse(lineBreaks ff n x))) -- (x,[" "])
       
        where mini   | length (lineBreaks ff n x) > 1 =  minimum (a (init(reverse(lineBreaks ff n x))))
                     | otherwise = minimum (a (lineBreaks ff n x))
                                    where a (x:xs) = [lineCost (fst x)] ++ a xs
                                          a [] = []
-- Times up :(


--
-- Finally define a function that justifies a given text into a list of lines satisfying a given width constraint.
-- The function should take a cost function, hyphenation map, maximum line width, and a text string as input and return a list of
-- strings.
--
-- 'justifyText lineCost enHyp 15 text1' should give you the example at the start of the assignment.
--
-- You might find the words and unwords functions useful.
--


--justifyText :: ([String] -> Double) -> [(String, [String])] -> Int -> String -> [String]
-- Function definition here














