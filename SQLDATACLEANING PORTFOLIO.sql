--/Cleaning data in SQL/


SELECT *
 FROM [Portifolio Project].[dbo].[NashvilleHousing]

 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --STANDARDIZE DATE FORMAT

 SELECT SaleDateConverted ,  CONVERT(Date,SaleDate)
  FROM [Portifolio Project].[dbo].[NashvilleHousing]

 ALTER TABLE NashvilleHousing
 Add SaleDateConverted Date;

 UPDATE NashvilleHousing
 SET SaleDateConverted = CONVERT(Date,SaleDate)

 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --POPULATE PROPERTY ADDRESS


  SELECT *
  FROM [Portifolio Project].[dbo].[NashvilleHousing]
  --WHERE PropertyAddress IS NULL
  ORDER BY ParcelID



  SELECT a.ParcelID,a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM [Portifolio Project].[dbo].[NashvilleHousing] a
  JOIN [Portifolio Project].[dbo].[NashvilleHousing] b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ]  <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL


--Checking if it's null
  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM [Portifolio Project].[dbo].[NashvilleHousing] a
  JOIN [Portifolio Project].[dbo].[NashvilleHousing] b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ]  <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  --BREAKING THE ADDRESS COLUMN INTO ADRESS, CITY AND STATE

  SELECT PropertyAddress
  FROM [Portifolio Project].[dbo].[NashvilleHousing]
  --WHERE PropertyAddress IS NULL
  --ORDER BY ParcelID


  SELECT
  SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress) -1) as Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress))as Address
   FROM [Portifolio Project].[dbo].[NashvilleHousing]

   
 ALTER TABLE NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);

 UPDATE NashvilleHousing
 SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress) -1) 


ALTER TABLE NashvilleHousing
 Add PropertySplitCity Nvarchar(255);

 UPDATE NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress))


 
 SELECT *
  FROM [Portifolio Project].[dbo].[NashvilleHousing]




  
 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
 ,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
   , PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
  FROM [Portifolio Project].[dbo].[NashvilleHousing]


  ALTER TABLE NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)


ALTER TABLE NashvilleHousing
 Add OwnerSplitCity Nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


 
ALTER TABLE NashvilleHousing
 Add OwnerSplitState Nvarchar(255);

 UPDATE NashvilleHousing
 SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

  SELECT *
  FROM [Portifolio Project].[dbo].[NashvilleHousing]

  
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  --CHANGE Y ,N TO YES NO IN SOLDASVACANT COLUMN

    SELECT DISTINCT SoldAsVacant, count(SoldAsVacant)
  FROM [Portifolio Project].[dbo].[NashvilleHousing]
  Group by SoldAsVacant
  order by 2


  SELECT SoldAsVacant
  , CASE When SoldAsVacant = 'Y' THEN 'Yes'
         When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
  FROM [Portifolio Project].[dbo].[NashvilleHousing]

  UPDATE NashvilleHousing
  SET  SoldAsVacant= CASE When SoldAsVacant = 'Y' THEN 'Yes'
         When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		 --REMOVING DUPLICATES
WITH RowNumCTE AS(
SELECT *, 
 ROW_NUMBER() OVER(

 PARTITION BY ParcelId, 
            PropertyAddress, 
			SalePrice,
			SaleDate, 
			LegalReference
			ORDER BY 
			UniqueID
			) row_num
 
  FROM [Portifolio Project].[dbo].[NashvilleHousing]
  --ORDER BY ParcelID
  )
  DELETE 
  FROM RowNumCTE
  WHERE row_num > 1 
  --ORDER BY PropertyAddress


  --- CHECKING IF  THERE ARE ANY DUPLICATES LEFT.

  WITH RowNumCTE AS(
SELECT *, 
 ROW_NUMBER() OVER(

 PARTITION BY ParcelId, 
            PropertyAddress, 
			SalePrice,
			SaleDate, 
			LegalReference
			ORDER BY 
			UniqueID
			) row_num
 
  FROM [Portifolio Project].[dbo].[NashvilleHousing]
  --ORDER BY ParcelID
  )
  SELECT *
  FROM RowNumCTE
  WHERE row_num > 1 
  ORDER BY PropertyAddress


--------------------------------------------------------------------------------------------------------------------


  --DELETING COLUMNS

  SELECT *
  FROM [Portifolio Project].[dbo].[NashvilleHousing]

  ALTER TABLE [Portifolio Project].[dbo].[NashvilleHousing]
  DROP  COLUMN OwnerAddress, TaxDistrict,PropertyAddress

   ALTER TABLE [Portifolio Project].[dbo].[NashvilleHousing]
  DROP  COLUMN SaleDate