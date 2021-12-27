{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TemplateHaskell #-}

-------------------------------------------------------------------

-- |
-- Module       : Data.Geospatial.Internal.Geometry.GeoMultiLine
-- Copyright    : (C) 2014-2019 HS-GeoJSON Project
-- License      : BSD-style (see the file LICENSE.md)
-- Maintainer   : Andrew Newman
module Data.Geospatial.Internal.Geometry.GeoMultiLine
  ( -- * Type
    GeoMultiLine (..),

    -- * Lenses
    unGeoMultiLine,

    -- * To Points
    splitGeoMultiLine,
    mergeGeoLines,
  )
where

import Control.DeepSeq
import Control.Lens (makeLenses)
import Control.Monad (mzero)
import Data.Aeson
  ( FromJSON (..),
    ToJSON (..),
    Value (..),
  )
import Data.Geospatial.Internal.BasicTypes
import Data.Geospatial.Internal.Geometry.Aeson
import Data.Geospatial.Internal.Geometry.GeoLine
import Data.LineString
import qualified Data.Sequence as Sequence
import GHC.Generics (Generic)

newtype GeoMultiLine = GeoMultiLine {_unGeoMultiLine :: Sequence.Seq (LineString GeoPositionWithoutCRS)} deriving (Show, Eq, Generic, NFData)

makeLenses ''GeoMultiLine

-- | Split GeoMultiLine coordinates into multiple GeoLines
splitGeoMultiLine :: GeoMultiLine -> Sequence.Seq GeoLine
splitGeoMultiLine = fmap GeoLine . _unGeoMultiLine

-- | Merge multiple GeoLines into one GeoMultiLine
mergeGeoLines :: Sequence.Seq GeoLine -> GeoMultiLine
mergeGeoLines = GeoMultiLine . fmap _unGeoLine

-- instances

instance ToJSON GeoMultiLine where
  --  toJSON :: a -> Value
  toJSON = makeGeometryGeoAeson "MultiLineString" . _unGeoMultiLine

instance FromJSON GeoMultiLine where
  --  parseJSON :: Value -> Parser a
  parseJSON (Object o) = readGeometryGeoAeson "MultiLineString" GeoMultiLine o
  parseJSON _ = mzero
