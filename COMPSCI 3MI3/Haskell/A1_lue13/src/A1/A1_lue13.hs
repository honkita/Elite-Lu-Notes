-- | Evaluator for Assignment 1.
module A1.A1_lue13 where
    
data Expr =
    EInt Integer
  | ECh Char
  | EBool Bool
  | EString String
  --
  | EAdd Expr Expr    -- addition of integers
  | EMul Expr Expr    -- multiplication of integers
  | ENeg Expr         -- negation of integers
  | ECat Expr Expr    -- concatenation of strings
  | ECons Char Expr   -- adding a character at the start of a string
  | EAnd Expr Expr    -- AND of two booleans
  | EXor Expr Expr    -- XOR of two booleans
  | EIf Expr Expr Expr -- if-then-else
  | EShowInt Expr      -- render an integer as a string

data Val =
    VInt Integer
  | VBool Bool
  | VString String
  | VError             -- something went wrong
  deriving (Show, Eq)

evalExpr :: Expr -> Val

--Basic Functions
evalExpr (EInt i) = VInt i
evalExpr (ECh c) = VString [c]
evalExpr (EBool b) = VBool b
evalExpr (EString s) = VString s

--EAdd Functions 
evalExpr (EAdd (EInt a) b) = --First val is an EInt
    let u = evalExpr(b) in case u of
        VInt x -> VInt (a + x)
        _ -> VError

evalExpr (EAdd a (EInt b)) = evalExpr(EAdd (EInt b) a) --Second val is an EInt, swap since addition is commutative

evalExpr (EAdd a b) = --If both values are expressions, then evaluate one side then use previously defined functions
    let u = evalExpr(a) in case u of
        VInt x -> evalExpr(EAdd(EInt x) b)
        _ -> VError

--EMul Functions
--Note: Copied from EAdd since they are the same other than operation
evalExpr (EMul (EInt a) b) = --First val is an EInt
    let u = evalExpr(b) in case u of
        VInt x -> VInt (a * x)
        _ -> VError

evalExpr (EMul a (EInt b)) = evalExpr(EMul (EInt b) a) --Second val is an EInt, swap since addition is commutative

evalExpr (EMul a b) = --If both values are expressions, then evaluate one side then use previously defined functions
    let u = evalExpr(a) in case u of
        VInt x -> evalExpr(EMul(EInt x) b)
        _ -> VError

--ENeg
evalExpr (ENeg a) =
    let u = evalExpr(a) in case u of
        VInt x -> VInt (-x)
        _ -> VError

--ECat
evalExpr (ECat a b) =
    let a' = evalExpr(a)
    in case a' of
        VString a'' -> (
            let b' = evalExpr(b)
            in case b' of 
                VString b'' -> VString(a''++b'')
                _ -> VError)
        _ -> VError

--ECon
evalExpr (ECons a b) = 
    let b' = evalExpr(b)
    in case b' of
        VString b'' -> VString ([a] ++ b'')
        _ -> VError

--EAnd
evalExpr (EAnd (EBool a) b) = --First val is an Bool
    let u = evalExpr(b) in case u of
        VBool x -> VBool (a && x)
        _ -> VError

evalExpr (EAnd a (EBool b)) = evalExpr(EAnd (EBool b) a) --Second val is an Bool, swap since Boolean AND is commutative

evalExpr (EAnd a b) = --If both values are expressions, then evaluate one side then use previously defined functions
    let u = evalExpr(a) in case u of
        VBool x -> evalExpr(EAnd(EBool x) b)
        _ -> VError

--EXor
evalExpr (EXor (EBool a) b) = --First val is an Bool
    let u = evalExpr(b) in case u of
        VBool x -> VBool (a /= x)
        _ -> VError

evalExpr (EXor a (EBool b)) = evalExpr(EXor (EBool b) a) --Second val is an Bool, swap since Boolean AND is commutative

evalExpr (EXor a b) = --If both values are expressions, then evaluate one side then use previously defined functions
    let u = evalExpr(a) in case u of
        VBool x -> evalExpr(EXor(EBool x) b)
        _ -> VError

--EIf
evalExpr (EIf a b c) =  --Similar to previous ones where evaluates and checks if a boolean value comes from a. Then proceeds to pick b or c
    let a' = evalExpr(a) in case a' of 
        VBool a'' -> (
            if a'' then evalExpr(b)
            else evalExpr(c)
            )
        _ -> VError

--EShowInt Functions
evalExpr (EShowInt(a)) = 
    let u = evalExpr(a) in case u of 
        VInt x -> VString (show(x))
        _ -> VError

