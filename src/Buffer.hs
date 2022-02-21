module Buffer (Buffer (..), empty, fromList, get, dump) where

import Data.MultiMap (MultiMap)
import qualified Data.MultiMap as MM
import qualified Data.Set as Set
import Data.Text (Text)
import qualified Data.Text as T

newtype Buffer = Buffer {unBuffer :: MultiMap Text Text}

empty :: Buffer
empty = Buffer MM.empty

fromList :: [(Text, Text)] -> Buffer
fromList keyvals = compact $ Buffer (MM.fromList (filter nonempty keyvals))
    where nonempty (k,v) = not $ T.null k || T.null v

compact :: Buffer -> Buffer
{-# INLINE compact #-}
compact = Buffer . MM.fromMap . fmap Set.toList . MM.toMapOfSets . unBuffer

get :: Text -> Buffer -> [Text]
get k = MM.lookup k . unBuffer

dump :: Buffer -> [(Text, Text)]
dump = MM.toList . unBuffer