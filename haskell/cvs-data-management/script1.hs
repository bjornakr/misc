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

extractDataForCase :: [[String]] -> IdIndex -> Id -> Either Error [DataVar]
extractDataForCase ds (aa@(IdIndex idx)) (bb@(Id id0)) =         --i <- r (!!) idx
    let filterF row = fmap (== id0) (atMay row idx) in
    
    let extractedCase = do
        k <- filterM filterF ds
        l <- headMay k
        return l    
        in

    case extractedCase of
        Nothing -> Left $ Error ("Could not find case with id " ++ (show id0) ++ " at index " ++ (show idx) ++ ".")
        Just h -> Right $ map DataVar h

        


header = extractHeader dataz


xow = do
    h <- header
    idx <- idIndex h
    d <- extractDataForCase dataz idx (Id "200BB")
    return d



main = do   
    let a = [1, 2, 3, 4]
    putStrLn "Hello world!"
