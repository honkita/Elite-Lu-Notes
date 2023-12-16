-- | Tests for question 1
module SKITests (skiTests) where

import A3.SKI
import Test.HUnit

-- TODO: Write tests for 'SKI'.
skiTests :: Test
skiTests = TestList 
    [
    -- Basic Tests to check S, K, and I
    -- All are supposed to return Nothing!
    TestCase (assertEqual "SKI Basic Test 1" (ski S) (Nothing)),
    TestCase (assertEqual "SKI Basic Test 2" (ski K) (Nothing)),
    TestCase (assertEqual "SKI Basic Test 3" (ski I) (Nothing)),

    -- Tests with App
    TestCase (assertEqual "SKI Basic App Test 1" (ski (App I S) ) (Just S)),
    TestCase (assertEqual "SKI Basic App Test 2" (ski (App S S) ) (Nothing)),
    TestCase (assertEqual "SKI Basic App Test 3" (ski (App K S) ) (Nothing)),
    TestCase (assertEqual "SKI App Test 1" (ski (App (App (App S S) K) I)) (Just (App (App S I) (App K I)))),
    TestCase (assertEqual "SKI App Test 2" (ski (App (App K S) I)) (Just S)),
    TestCase (assertEqual "SKI App Test 3" (ski (App (App S S) (App S S))) (Nothing)), --brackets matter since this is (SS)(SS), which can not be evaluated
    TestCase (assertEqual "SKI App Test 4" (ski (App (App I (App S K)) (App S K))) (Just (App (App S K) (App S K)))),
    TestCase (assertEqual "SKI App Test 5" (ski (App (App (App S K) S) (App K I))) (Just (App (App K (App K I)) (App S (App K I))))),

    TestCase (assertEqual "SKI Final Test UwU" (ski (App (App (App S K) (App S K)) (App K I))) (Just (App (App K (App K I)) (App (App S K) (App K I)))))
    ]

