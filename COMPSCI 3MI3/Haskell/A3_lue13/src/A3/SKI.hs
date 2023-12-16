module A3.SKI where
    
data SKI
    = S
    | K
    | I
    | App SKI SKI
    deriving (Eq, Show)   
-- * Question 1: Revenge of the Goblins and Gnomes
ski :: SKI -> Maybe SKI

ski (App fn arg) =
    case ski fn of
        Just vfn -> Just (App vfn arg) -- evaluate the start of the function
        Nothing ->
            case ski arg of -- checks if the argument can or can not be evaluated
                Just arg2 ->
                    Just (App fn arg2) --evaluates the argument if the start of the function can not
                Nothing -> -- when the function and argument can not be evaluated
                    case fn of -- checks function type
                        (App (App S x) y) -> Just (App (App x arg) (App y arg)) -- Must be in this format since this assumes left association as ((S_)_)_, which is what is required
                        (App K x) -> Just x
                        I -> Just arg
                        _ -> Nothing

ski _ = Nothing -- "ski S", "ski K", and "ski I" can not be reduced, thus this base case is invoked!

