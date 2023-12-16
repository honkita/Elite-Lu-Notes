-- | Tests for Assignment 1.
module Main where

import A1.A1_lue13

import Test.HUnit
import System.Exit

-- All the tests are labelled with the strings
a1Tests :: Test
a1Tests = TestList
  [ 
  --Basic Tests for the single entry expressions (One Computation)
  --Includes the following:
  --EAdd
  --ECh
  --EBool
  --EString
  --EShowInt
  --ENeg
  TestCase(assertEqual "Basic EInt Test evalExpr (Eint 5) == VInt 5" (evalExpr(EInt 5)) (VInt 5)),
  TestCase(assertEqual "Basic ECh Test evalExpr (ECh 'e') == VString \"e\"" (evalExpr (ECh 'e'))(VString "e")),
  TestCase(assertEqual "Basic EBool Test evalExpr (EBool True) == VBool True" (evalExpr (EBool True))(VBool True)),
  TestCase(assertEqual "Basic EString Test evalExpr (EString \"Elite Lu\") == VString \"Elite Lu\"" (evalExpr (EString "Elite Lu"))(VString "Elite Lu")),
  TestCase(assertEqual "Basic EShowInt Test 1 evalExpr (EShowInt (EBool True)) == VError" (evalExpr (EShowInt (EBool True)))(VError)),
  TestCase(assertEqual "Basic EShowInt Test 2 evalExpr (EShowInt (EInt 5)) == VString \"5\"" (evalExpr (EShowInt (EInt 5)))(VString "5")),
  TestCase(assertEqual "Basic ENeg Test 1 evalExpr (ENeg (EInt 5)) == VInt (-5)" (evalExpr (ENeg (EInt 5))) (VInt (-5))),
  TestCase(assertEqual "Basic ENeg Test 2 evalExpr (ENeg (EInt (-69))) == VInt 69" (evalExpr (ENeg (EInt (-69)))) (VInt 69)),
  TestCase(assertEqual "Basic ENeg Test 3 evalExpr (ENeg (ECh 'e')) == VError" (evalExpr (ENeg (ECh 'e'))) (VError)),

  --Basic Tests for the double entry expressions (One Computation)
  --Includes the following
  --EAdd
  --EMul
  --ECat
  --ECons
  --EAnd
  --EXor
  TestCase(assertEqual "Basic EAdd Test 1 evalExpr (EAdd (EInt 5) (EInt 20)) == VInt 25" (evalExpr (EAdd (EInt 5) (EInt 20)))(VInt 25)),
  TestCase(assertEqual "Basic EAdd Test 2 evalExpr (EAdd (EBool False) (EInt 20)) == VError" (evalExpr (EAdd (EBool False) (EInt 20)))(VError)),
  TestCase(assertEqual "Basic EAdd Test 3 evalExpr (EAdd (EInt 0) (EString \"Ur Mom\")) == VError" (evalExpr (EAdd (EInt 0) (EString "Ur Mom")))(VError)),
  TestCase(assertEqual "Basic EMul Test 1 evalExpr (EMul (EInt 5) (EInt 20)) == VInt 100" (evalExpr (EMul (EInt 5) (EInt 20)))(VInt 100)),
  TestCase(assertEqual "Basic EMul Test 2 evalExpr (EMul (EBool False) (EInt 20)) == VError" (evalExpr (EMul (EBool False) (EInt 20)))(VError)),
  TestCase(assertEqual "Basic EMul Test 3 evalExpr (EMul (EInt 0) (EString \"Ur Mom\")) == VError" (evalExpr (EMul (EInt 0) (EString "Ur Mom")))(VError)),
  TestCase(assertEqual "Basic ECat Test 1 evalExpr (ECat (EString \"Dream\") (EString \"catcher\")) == VString \"Dreamcatcher\"" (evalExpr(ECat (EString "Dream") (EString "catcher")))(VString "Dreamcatcher")),
  TestCase(assertEqual "Basic ECat Test 2 evalExpr (ECat (EString \"fromis\") (EInt 9)) == VError" (evalExpr(ECat (EString "fromis") (EInt 9)))(VError)),
  TestCase(assertEqual "Basic ECons Test 1 evalExpr (ECons 'l' (ECh 'u')) == VString \"lu\"" (evalExpr (ECons 'l' (ECh 'u')))(VString "lu")),
  TestCase(assertEqual "Basic ECons Test 2 evalExpr (ECons 'A' (EInt 4)) == VError" (evalExpr(ECons 'A' (EInt 4)))(VError)),
  TestCase(assertEqual "Basic EAnd Test 1 evalExpr (EAnd (EBool True) (EBool True)) == VBool True" (evalExpr (EAnd (EBool True) (EBool True)))(VBool True)),
  TestCase(assertEqual "Basic EAnd Test 2 evalExpr (EAnd (EBool True) (EBool False)) == VBool False" (evalExpr (EAnd (EBool True) (EBool False)))(VBool False)),
  TestCase(assertEqual "Basic EAnd Test 3 evalExpr (EAnd (EBool False) (EBool True)) == VBool False" (evalExpr (EAnd (EBool False) (EBool True)))(VBool False)),
  TestCase(assertEqual "Basic EAnd Test 4 evalExpr (EAnd (EBool False) (EBool False)) == VBool False" (evalExpr (EAnd (EBool False) (EBool False)))(VBool False)),
  TestCase(assertEqual "Basic EAnd Test 5 evalExpr (EAnd (EBool True) (EInt 1)) == VError" (evalExpr (EAnd (EBool True) (EInt 1)))(VError)),
  TestCase(assertEqual "Basic EAnd Test 6 evalExpr (EAnd (EString \"poopy\") (EBool False)) == VError" (evalExpr (EAnd (EString "poopy") (EBool False)))(VError)),
  TestCase(assertEqual "Basic EAnd Test 7 evalExpr (EAnd (ECh 'x') (EInt 1)) == VError" (evalExpr (EAnd (ECh 'x') (EInt 1)))(VError)),
  TestCase(assertEqual "Basic EXor Test 1 evalExpr (EXor (EBool True) (EBool True)) == VBool False" (evalExpr (EXor (EBool True) (EBool True)))(VBool False)),
  TestCase(assertEqual "Basic EXor Test 2 evalExpr (EXor (EBool True) (EBool False)) == VBool True" (evalExpr (EXor (EBool True) (EBool False)))(VBool True)),
  TestCase(assertEqual "Basic EXor Test 3 evalExpr (EXor (EBool False) (EBool True)) == VBool True" (evalExpr (EXor (EBool False) (EBool True)))(VBool True)),
  TestCase(assertEqual "Basic EXor Test 4 evalExpr (EXor (EBool False) (EBool False)) == VBool False" (evalExpr (EXor (EBool False) (EBool False)))(VBool False)),
  TestCase(assertEqual "Basic EXor Test 5 evalExpr (EXor (EString \"I hate this assignment\") (EBool True)) == VError" (evalExpr (EXor (EString "I hate this assignment") (EBool True)))(VError)),
  TestCase(assertEqual "Basic EXor Test 6 evalExpr (EXor (EBool False) (EString \"Ahri\")) == VError" (evalExpr (EXor (EBool False) (EString "Ahri")))(VError)),
  TestCase(assertEqual "Basic EXor Test 7 evalExpr (EXor (EString \"o no\") (ECh 'a')) == VError" (evalExpr (EXor (EString "o no") (ECh 'a')))(VError)),

   --Basic Tests for the single entry expressions (Three Computations)
   --Includes the following
   --EIf
  TestCase(assertEqual "Basic EIf Test 1 evalExpr (EIf (EBool True) (ECh 'a') (ECh 'b')) == VString \"a\"" (evalExpr (EIf (EBool True) (ECh 'a') (ECh 'b')))(VString "a")),
  TestCase(assertEqual "Basic EIf Test 1 evalExpr (EIf (EBool False) (EInt 5529) (ECh 'b')) == VString \"b\"" (evalExpr (EIf (EBool False) (EInt 5529) (ECh 'b')))(VString "b")),
  TestCase(assertEqual "Basic EIf Test 1 evalExpr (EIf (ECh 'n') (EBool False) (EString \"So many test cases\")) == VError" (evalExpr (EIf (ECh 'n') (EBool False) (EString "So many test cases")))(VError)),

  --Student ID Tests
  --Note: My student ID is 400364692 and Mac ID is lue13
  --Includes the following
  --EAdd
  --EMul
  --ECat
  --ECons
  --EShowInt
  TestCase(assertEqual "Mac ID Test 1 evalExpr (ECat (ECons 'l' (ECons 'u' (ECh 'e')))(EShowInt(EInt 13))) == VString \"lue13\"" (evalExpr (ECat(ECons 'l' (ECons 'u' (ECh 'e')))(EShowInt(EInt 13))))(VString "lue13")),
  TestCase(assertEqual "Mac ID Test 2 evalExpr (ECat (EString \"lue\")(ECons '1' (EShowInt(EInt 3)))) == VString \"lue13\"" (evalExpr (ECat(EString "lue")(ECons '1' (EShowInt(EInt 3)))))(VString "lue13")),
  TestCase(assertEqual "Mac ID Test 3 evalExpr (ECat (EString \"lue\")(ECons '1' (EShowInt(EInt 3)))) == VString \"lue13\"" (evalExpr (ECat(EString "lue")(ECons '1' (EShowInt(EInt 3)))))(VString "lue13")),
  TestCase(assertEqual "Student ID Test 1 evalExpr (EShowInt (EMul (EInt 22447) (EMul (EInt 13) (EMul (EInt 7) (EMul (EInt 49) (EInt 4)))))) == VString \"400364692\"" (evalExpr (EShowInt(EMul (EInt 22447) (EMul (EInt 13) (EMul (EInt 7) (EMul (EInt 49) (EInt 4)))))))(VString "400364692")),
  TestCase(assertEqual "Student ID Test 2 evalExpr (EShowInt (EAdd (EMul (EInt 4) (EInt 100000000)) (EAdd (EMul (EInt 3) (EInt 100000)) (EAdd (EMul (EInt 6) (EInt 10000)) (EAdd (EMul (EInt 4) (EInt 1000))(EAdd (EMul (EInt 6) (EInt 100))(EAdd (EMul (EInt 9) (EInt 10)) (EInt 2)))))))) == VString \"400364692\"" (evalExpr(EShowInt (EAdd (EMul (EInt 4) (EInt 100000000)) (EAdd (EMul (EInt 3) (EInt 100000)) (EAdd (EMul (EInt 6) (EInt 10000)) (EAdd (EMul (EInt 4) (EInt 1000))(EAdd (EMul (EInt 6) (EInt 100))(EAdd (EMul (EInt 9) (EInt 10)) (EInt 2)))))))))(VString "400364692")),
  TestCase(assertEqual "Student ID Test 3 evalExpr (EShowInt (EAdd (EMul (EMul (ENeg(EInt 420)) (EInt 420)) (EMul (ENeg(EInt 42)) (EInt 66))) (ENeg (EInt 88616108)))) == VString \"400364692\"" (evalExpr(EShowInt (EAdd (EMul (EMul (ENeg(EInt 420)) (EInt 420)) (EMul (ENeg(EInt 42)) (EInt 66))) (ENeg (EInt 88616108))))) (VString "400364692")),

  --Multi recursive tests
  --Testing for EShowInt, EAdd, EMul, ECat, and ECons will not be tested as extensively because of the student ID tests
  --Note: a and b tests are the same except for one thing, which determines if it is an error or not
  --Example of this would be 3a and 3b, where a VError is thrown for 3b because there is no EShowInt
  --Some types of tests include
  --Nested EAnd and EXor
  --Double EShowInt
  --Nested EAdd and EMul
  --ECons with EShowInt and nested EAdd and EMul
  TestCase(assertEqual "Multi Recursive Test 1 evalExpr (EIf (ECh 'n') (EBool False) (EString \"So many test cases\")) == VError" (evalExpr (EIf (ECh 'n') (EBool False) (EString "So many test cases")))(VError)),
  TestCase(assertEqual "Multi Recursive Test 2 evalExpr (EAnd (EXor (EAnd (EBool True) (EBool False)) (EXor (EBool True) (EBool False))) (EBool False)) == VBool False" (evalExpr (EAnd (EXor (EAnd (EBool True) (EBool False)) (EXor (EBool True) (EBool False))) (EBool False)))(VBool False)),
  TestCase(assertEqual "Multi Recursive Test 3a evalExpr (ECons 'a' (EShowInt (EAdd (EMul (EInt 4) (EInt 9)) (EInt 12)))) == VString \"a48\"" (evalExpr (ECons 'a' (EShowInt (EAdd (EMul (EInt 4) (EInt 9)) (EInt 12)))))(VString "a48")),
  TestCase(assertEqual "Multi Recursive Test 3b evalExpr (ECons 'a' (EAdd (EMul (EInt 4) (EInt 9)) (EInt 12))) == VError" (evalExpr (ECons 'a' (EAdd (EMul (EInt 4) (EInt 9)) (EInt 12))))(VError)),
  TestCase(assertEqual "Multi Recursive Test 4 evalExpr (EShowInt (EShowInt (EInt 11111122222))) == VError" (evalExpr (EShowInt (EShowInt (EInt 11111122222))))(VError)),
  TestCase(assertEqual "Multi Recursive Test 5 evalExpr (EXor (EAnd (EString \"I'm running out of ideas\") (EBool False)) (EBool False)) == VError" (evalExpr (EXor (EAnd (EString "I’m running out of ideas") (EBool False)) (EBool False)))(VError)),
  TestCase(assertEqual "Multi Recursive Test 6 evalExpr (EAnd (EXor (EAnd (EBool True) (EBool True)) (EAnd (EBool True) (EBool True))) (EXor (EAnd (EBool True) (EBool True)) (EAnd (EBool True) (EBool True)))) == VBool False" (evalExpr (EAnd (EXor (EAnd (EBool True) (EBool True)) (EAnd (EBool True) (EBool True))) (EXor (EAnd (EBool True) (EBool True)) (EAnd (EBool True) (EBool True)))))(VBool False)),
  TestCase(assertEqual "Multi Recursive Test 7a evalExpr (EAdd (EInt 5) (EMul (EAdd (EInt 10) (EInt 99)) (EInt 67))) == VInt 7308" (evalExpr (EAdd (EInt 5) (EMul (EAdd (EInt 10) (EInt 99)) (EInt 67))))(VInt 7308)),
  TestCase(assertEqual "Multi Recursive Test 7b evalExpr (EAdd (EShowInt (EInt 5)) (EMul (EAdd (EInt 10) (EInt 99)) (EInt 67))) == VError" (evalExpr (EAdd (EShowInt (EInt 5)) (EMul (EAdd (EInt 10) (EInt 99)) (EInt 67))))(VError)),

  --Final Test
  TestCase(assertEqual "Final Test evalExpr (evalExpr (EIf (EIf (EXor (EBool True) (EBool False)) (EAnd (EBool False) (EBool True)) (EInt 99)) (ECh Truea') (EString \"Should be this instead of the other one\"))" (evalExpr (EIf (EIf (EXor (EBool True) (EBool False)) (EAnd (EBool False) (EBool True)) (EInt 99)) (ECh 'a') (EString "Should be this instead of the other one"))) (VString "Should be this instead of the other one"))

  ]

-- Run the test suite. Please do not touch this!
main :: IO ()
main = do
    counts <- runTestTT a1Tests
    if errors counts + failures counts == 0 then
      exitSuccess
    else
      exitFailure
