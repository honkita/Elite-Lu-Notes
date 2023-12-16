-- |
module LoopyLambdaTests (lambdaTests) where

import A3.LoopyLambda
import Test.HUnit

-- | Helper for testing α-equivalence of expressions.
assertAlphaEqual :: String -> Expr -> Expr -> Assertion
assertAlphaEqual msg e1 e2 = assertBool msg (alphaEq e1 e2)

-- | Because no helper was provided for Maybe Expr THANKS
-- | Does the exact same thing as assertAlphaEqual but for Maybe Expr

assertAlphaEqualBetter :: String -> Maybe Expr -> Maybe Expr -> Assertion
assertAlphaEqualBetter msg e1 e2 = assertBool msg (alphaEqBetter e1 e2)

-- | Converts an integer to PlusOne(Zero) format like Succ Zero
-- | I mean this could be done normally but it would take way too long

numberToExpr :: Integer -> Expr
numberToExpr 0 = Zero
numberToExpr i = PlusOne (numberToExpr (i-1))

-- Note: I can not assetEqual since the data type does not derive from Eq.
-- This is because given something like λxλy.x  and λaλb.a, both of these are not the same
-- when viewing it as a Expr. However, they are equal but with different names. Because of 
-- this, I will make my own helper function.  
lambdaTests :: Test
lambdaTests = TestList
  [ 
  TestCase (assertAlphaEqual "Variable Swapping Lambda Calc" (Lam "Ur Mom" ((Lam "UrMom" (Var "UrMom"))))  (Lam "Deez Nuts" ((Lam "DeezNuts" (Var "DeezNuts"))))),
  -- Because swap names works, whenever I test lambda calculus, it does not matter on what the name of the variable is

  -- Basic Tests for Var, Lam, Zero, PlusOne
  TestCase (assertAlphaEqualBetter "Basic Test for Var" (stepLoop (Var "IDK WHAT TO WRITE HERE")) (stepLoop (Var "UWU"))), -- Both evaulate as Nothing
  TestCase (assertAlphaEqualBetter "Basic Test for Lam" (stepLoop (Lam "Ur Mom" ((Lam "UrMom" (Var "UrMom"))))) (stepLoop (Lam "Deez Nuts" ((Lam "DeezNuts" (Var "DeezNuts")))))), -- Both evaluate as Nothing
  TestCase (assertAlphaEqualBetter "Basic Test for Zero" (stepLoop Zero) (Nothing)), --Zero evaluates as Nothing
  TestCase (assertAlphaEqualBetter "Basic Test for PlusOne" (stepLoop (PlusOne Zero)) (Nothing)), -- PlusOne evaluates as Nothing since Zero can not be evaluated 

  -- Tests for PlusOne
  TestCase (assertAlphaEqualBetter "Test for PlusOne 1" (stepLoop (PlusOne (App (Lam "x" (Var "x")) (Var "UwU")))) (Just (PlusOne (Var "UwU")))), -- Basic test case to see if the inside arguments evaluate
  TestCase (assertAlphaEqualBetter "Test for PlusOne 2 (Omega Combinator)" (stepLoop (PlusOne (App (Lam "x" (App (Var "x") (Var "x"))) (Lam "x" (App (Var "x") (Var "x")))))) (Just (PlusOne (App (Lam "x" (App (Var "x") (Var "x"))) (Lam "x" (App (Var "x") (Var "x"))))))), --Omega Combinator
  
  -- Tests for App

  -- Var, Zero, and PlusOne are not valid functions, thus nothing happens
  TestCase (assertAlphaEqualBetter "Basic Test for App PlusOne" (stepLoop (App (PlusOne Zero) (Var "Hello"))) (Nothing)), 
  TestCase (assertAlphaEqualBetter "Basic Test for App Zero" (stepLoop (App Zero (Var "How are you?"))) (Nothing)), 
  TestCase (assertAlphaEqualBetter "Basic Test for App Var" (stepLoop (App (Var "Quite terrible.") Zero)) (Nothing)), 

  -- Lam, which does work since it is Lambda calculus and this is call by name!!!!
  TestCase (assertAlphaEqualBetter "Basic Test for App Lam 1" (stepLoop (App (Lam "Why" (Lam "bro" (Var "Why"))) (Var "What's wrong"))) (Just (Lam "bro" (Var "What's wrong")))),
  -- Tests if the this evaluates the function or the argument, which determines if it is call by name or value
  TestCase (assertAlphaEqualBetter "Basic Test for App Lam 2" (stepLoop (App (Lam "Just" (Lam "ain't" (Var "Just"))) (Lam "feeling" (Lam "it" (Var "it"))))) (Just (Lam "ain't" (Lam "feeling" (Lam "it" (Var "it")))))),


  -- Tests of Loop
  TestCase (assertAlphaEqualBetter "Basic Test for Loop e1 -> e1'" (stepLoop (Loop (App (Lam "This" (Lam "assignment" (Var "This"))) (Var "sucks")) (Var "a") (Var "lot"))) (Just (Loop (Lam "assignment" (Var "sucks")) (Var "a") (Var "lot")))),
  TestCase (assertAlphaEqualBetter "Basic Test for Loop Zero" (stepLoop (Loop Zero (Var "Welp RIP") (Var "Nothing you can do about it"))) (Just (Var "Welp RIP"))),
  TestCase (assertAlphaEqualBetter "Basic Test for Loop PlusOne" (stepLoop (Loop (PlusOne (Var "Yea")) (Var "unfortunate") (Var "RIP"))) (Just (App (Var "RIP") (Loop (Var "Yea") (Var "unfortunate") (Var "RIP"))))),
  TestCase (assertAlphaEqualBetter "Test for Loop Nested PlusOne 1" (stepLoop (Loop (PlusOne (PlusOne (Var "uwu"))) (Var "UrMom") (Var "UrMom"))) (Just (App (Var "UrMom") (Loop (PlusOne (Var "uwu")) (Var "UrMom") (Var "UrMom"))))),
  TestCase (assertAlphaEqualBetter "Test for Loop Nested PlusOne 2" (stepLoop (Loop (App (Lam "x" (Var "x")) (Var "UWU"))  (Zero) (Zero))) (Just (Loop (Var "UWU") Zero Zero))), -- checks if e1 can be simplified before applying the Loop PlusOne property

  -- Completes an entire lambda calc equation
  -- Original question is from the University of Maryland Practice Test. This question was done with full beta, which is non deterministic.
  -- I am using it to test for Call by Name
  -- Original question: (λx.x)(λy.y y)(λa.a c)
  -- (λx.x)(λy.y y)(λa.a c)
  -- -> (λy.y y)(λa.a c)
  -- -> (λa.a c)(λa.a c)
  -- -> c (λa.a c)
  -- -> DONE
  TestCase (assertAlphaEqualBetter "Test for Lambda Calculus Step 1" (stepLoop (App (App (Lam "X" (Var "X")) (Lam "Y" (App (Var "Y") (Var "Y")))) (App (Lam "A" (Var "A")) (Var "C")))) (Just (App (Lam "Y" (App (Var "Y") (Var "Y"))) (App (Lam "A" (Var "A")) (Var "C"))))),
  TestCase (assertAlphaEqualBetter "Test for Lambda Calculus Step 2" (stepLoop (App (Lam "Y" (App (Var "Y") (Var "Y"))) (App (Lam "A" (Var "A")) (Var "C")))) (Just (App (App (Lam "A" (Var "A")) (Var "C")) (App (Lam "A" (Var "A")) (Var "C"))))),
  TestCase (assertAlphaEqualBetter "Test for Lambda Calculus Step 3" (stepLoop (App (App (Lam "A" (Var "A")) (Var "C")) (App (Lam "A" (Var "A")) (Var "C")))) (Just (App (Var "C") (App (Lam "A" (Var "A")) (Var "C"))))),
  TestCase (assertAlphaEqualBetter "Test for Lambda Calculus Step 4" (stepLoop (App (Var "C") (App (Lam "A" (Var "A")) (Var "C")))) (Nothing)),



  -- Checks the omega combinator (λx.xx)(λx.xx) -> (λx.xx)(λx.xx)
  TestCase (assertAlphaEqualBetter "Test for App Omega Combinator" (stepLoop (App (Lam "X" (App (Var "X") (Var "X"))) (Lam "X" (App (Var "X") (Var "X"))))) (Just (App (Lam "X" (App (Var "X") (Var "X"))) (Lam "X" (App (Var "X") (Var "X")))))),


  -- Tests for student ID

  -- NOT THE ONES FOR THE REQUIREMENTS THOSE ARE BELOW. THESE ARE JUST FUN ONES BEFORE THE REQUIREMENT WAS EXPLAINED
  -- My ID is 400364692
  -- All of these tests will split the string into multiple parts, which are 400, 364, and 692!!!!!
  -- This tests where with Loop PlusOne where e3 is a Lambda expression and how it works!
  -- In addition to this, this will evaluate the whole function, as I am using the results of the previous step as the next test case
  TestCase (assertAlphaEqualBetter "Student ID Test 1 Step 1" (stepLoop (Loop (PlusOne (PlusOne (Var "400"))) (Var "364") (Lam "692" (Var "692")))) (Just (App (Lam "692" (Var "692")) (Loop (PlusOne (Var "400")) (Var "364") (Lam "692" (Var "692")))))),
  TestCase (assertAlphaEqualBetter "Student ID Test 1 Step 2" (stepLoop (App (Lam "692" (Var "692")) (Loop (PlusOne (Var "400")) (Var "364") (Lam "692" (Var "692"))))) (Just (Loop (PlusOne (Var "400")) (Var "364") (Lam "692" (Var "692"))))),
  TestCase (assertAlphaEqualBetter "Student ID Test 1 Step 3" (stepLoop (Loop (PlusOne (Var "400")) (Var "364") (Lam "692" (Var "692")))) (Just (App (Lam "692" (Var "692")) (Loop (Var "400") (Var "364") (Lam "692" (Var "692")))))),
  TestCase (assertAlphaEqualBetter "Student ID Test 1 Step 4" (stepLoop (App (Lam "692" (Var "692")) (Loop (Var "400") (Var "364") (Lam "692" (Var "692"))))) (Just (Loop (Var "400") (Var "364") (Lam "692" (Var "692"))))),
  TestCase (assertAlphaEqualBetter "Student ID Test 1 Step 5" (stepLoop (Loop (Var "400") (Var "364") (Lam "692" (Var "692")))) (Nothing)),

  -- Some more tests with my student number using the numberToExpr to create my SID
  -- My student ID's last two values are 92 so numberToExpr 92 is my student ID's final two numbers
  -- The code is ABOVE for the helper function numberToExpr
  TestCase (assertAlphaEqualBetter "Student ID Test 2" (stepLoop (App (Lam "x" (Var "x")) (numberToExpr 92))) (Just(numberToExpr 92))),
  TestCase (assertAlphaEqualBetter "Student ID Test 3" (stepLoop (Loop Zero (numberToExpr 92) (numberToExpr 69))) (Just(numberToExpr 92))),
  TestCase (assertAlphaEqualBetter "Student ID Test 4" (stepLoop (PlusOne (App (Lam "x" (Var "x")) (numberToExpr 91)) )) (Just(numberToExpr 92))),



  -- Final Test
  -- Function to be evaluated: Loop ((λx.x) (1 + 0)) (λy.y) (λy.y y)
  -- Loop ((λx.x) (1 + 0)) (λy.y) (λy.y y)
  -- -> Loop (1 + 0) (λy.y) (λy.y y)
  -- -> (λy.y y) (Loop 0 (λy.y) (λy.y y))
  -- -> (Loop 0 (λy.y) (λy.y y)) (Loop 0 (λy.y) (λy.y y))
  -- -> (λy.y) (Loop 0 (λy.y) (λy.y y))
  -- -> (Loop 0 (λy.y) (λy.y y))
  -- -> (λy.y)
  -- -> DONE
  TestCase (assertAlphaEqualBetter "Final Test Step 1" (stepLoop (Loop (App (Lam "X" (Var "X"))(PlusOne Zero)) (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))) (Just (Loop (PlusOne Zero) (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))))),
  TestCase (assertAlphaEqualBetter "Final Test Step 2" (stepLoop (Loop (PlusOne Zero) (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))) (Just (App (Lam "Y" (App (Var "Y") (Var "Y"))) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))))),
  TestCase (assertAlphaEqualBetter "Final Test Step 3" (stepLoop (App (Lam "Y" (App (Var "Y") (Var "Y"))) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))))) (Just (App (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))))),
  TestCase (assertAlphaEqualBetter "Final Test Step 4" (stepLoop (App (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))))) (Just (App (Lam "Y" (Var "Y")) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))))),
  TestCase (assertAlphaEqualBetter "Final Test Step 5" (stepLoop (App (Lam "Y" (Var "Y")) (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))))) (Just (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y")))))),
  TestCase (assertAlphaEqualBetter "Final Test Step 6" (stepLoop (Loop Zero (Lam "Y" (Var "Y")) (Lam "Y" (App (Var "Y") (Var "Y"))))) (Just (Lam "Y" (Var "Y")))),
  TestCase (assertAlphaEqualBetter "Final Test Step 7" (stepLoop (Lam "Y" (Var "Y"))) (Nothing))

  ]
