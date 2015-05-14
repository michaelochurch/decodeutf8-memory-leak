{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as LazyBytes
import qualified Data.Text.Lazy as LazyText
import Data.Text.Lazy.Encoding (decodeUtf8)

assert :: Bool -> IO ()
assert b = if b then return () else error "Assertion failed."

-- Courtesy of Michael Snoyman: https://gist.github.com/snoyberg/bfda1d0aac3f96c9d455
ex1 :: IO ()
ex1 = assert $ (=="foobar") $
      LazyText.take 6 $ decodeUtf8 $ LazyBytes.fromChunks ["foo", "bar", undefined]


ex2 :: IO ()
ex2 = assert $ (==99) $
      LazyBytes.last $ LazyBytes.fromChunks (replicate 100000000 "abc")

ex3 :: IO ()
ex3 = assert $ (=='Q') $
      LazyText.last $ LazyText.pack (replicate 300000000 'Q')

ex4 :: IO ()
ex4 = assert $ (=='c') $
      LazyText.last $ decodeUtf8 $ LazyBytes.fromChunks (replicate 100000000 "abc")

main :: IO ()
main = do
  ex1
  putStrLn "Laziness works."
  ex2
  putStrLn "Data.Bytestring.Lazy.last doesn't leak."
  ex3
  putStrLn "Data.Lazy.Text.last doesn't leak."
  ex4 -- This will fail if you run with RTS option -M120m (120 MB limit).
  putStrLn "Everything works!"
