#!/usr/bin/env stack
-- stack runghc --resolver lts-6.24 --install-ghc --package safe

import Data.List
import Safe
import Data.Either
import Control.Monad

data Error = Error String deriving (Show)
data HeaderVar = HeaderVar String deriving (Show, Eq)
data DataVar = DataVar String deriving (Show)
data Id = Id String deriving (Show)
data IdIndex = IdIndex Int deriving (Show)


idVar = "id"

dataz = [
            ["id", "var1", "v2", "v3"],
            ["100AA", "1", "2", "3"],
            ["200BB", "1", "2", "3"]
        ]



idIndex :: [HeaderVar] -> Either Error IdIndex
idIndex hs = 
    case elemIndex (HeaderVar idVar) hs of
        Nothing -> Left $ Error ("Could not find index of id in header with variable name: " ++ idVar)
        Just i  -> Right $ IdIndex i

extractHeader :: [[String]] -> Either Error [HeaderVar]
extractHeader [] = Left $ Error "Extract header on empty list."
extractHeader (s:ss) = Right $ map HeaderVar s


-- flatten a =
--     case a of
--         Left e -> Left e
--         Right (b@(Right _)) -> flatten b
--         Right b -> Right b


filterE :: (a -> Either Error Bool) -> [a] -> Either Error [a]
filterE f (x:xs) = filterM f (x:xs) 
    
-- proc f [] = []
-- proc f (x:xs) =
--     case f(x) of
--         Left e -> (Left e):proc f xs
--         Right(true) -> (Right(x):(proc f xs))
--         Right(false) -> proc f xs


-- filterF :: IdIndex -> Id -> [String] -> Maybe Bool
-- filterF (IdIndex idIdx) (Id id0) row = fmap (== id0) (atMay row idIdx)

extractDataForCase :: [[String]] -> IdIndex -> Id -> Either Error [DataVar]
extractDataForCase ds (aa@(IdIndex idx)) (bb@(Id id0)) =         --i <- r (!!) idx
    -- filterF :: IdIndex -> Id -> [String] -> Maybe Bool
    let filterF row = fmap (== id0) (atMay row idx) in
    
    let xxx = do
        k <- filterM filterF ds
        l <- headMay k
        return l    
        in

--    let j = filterM filterF ds in
--    let j = filterM (filterF aa bb) ds in
--    case (fmap headMay j) of
    case xxx of
        Nothing -> Left $ Error ("Could not find case with id " ++ (show id0) ++ " at index " ++ (show idx) ++ ".")
        Just h -> Right $ map DataVar h

        

    --let a = filter (\r -> (r !! idx) == id0) ds in --TODO: Safe get
    --map DataVar (headMay a)

header = extractHeader dataz


xow = do
    h <- header
    idx <- idIndex h
    d <- extractDataForCase dataz idx (Id "200BB")
    return d

-- bow = fmap (\i -> extractDataForCase dataz i (Id "999XX")) idx

-- xow = extractDataForCase dataz i (Id "999XX")) idx





--zf :: [[Header], [Data]] -> ([Header], [Data])
--zf ()

--zg :: (Header, Data) -> [(String, String)]
--zg ( ((h:hs), (d:ds)) ) = [(h, d)]




main = do   
    let a = [1, 2, 3, 4]
    putStrLn "Hello world!"
