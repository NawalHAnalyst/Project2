 -- cleaning data in SQL Queries

 select *
 from PortfolioProject.dbo.NashHousing
	 

 -- Standarize Date format

 select SaleDateConverted, CONVERT(Date,SaleDate)
 from PortfolioProject.dbo.NashHousing

 UPDATE NashHousing
 SET SaleDate = CONVERT(Date,SaleDate)

 ALTER TABLE NashHousing
 ADD SaleDateConverted DATE;

 UPDATE NashHousing
 SET SaleDateConverted = CONVERT(Date,SaleDate)

	 
 -- Populate Property Address Data

 select *
 from PortfolioProject.dbo.NashHousing
-- where PropertyAddress is null
order by ParcelID

 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.NashHousing a
 JOIN  PortfolioProject.dbo.NashHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.NashHousing a
 JOIN  PortfolioProject.dbo.NashHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking Address columns

 select PropertyAddress
 from PortfolioProject.dbo.NashHousing
-- where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashHousing

 ALTER TABLE NashHousing
 ADD PropertySplitAddress nvarchar(255);

 UPDATE NashHousing
 SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

  ALTER TABLE NashHousing
 ADD PropertySplitCity nvarchar(255);

 UPDATE NashHousing
 SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))


 select *
 from PortfolioProject.dbo.NashHousing


 select OwnerAddress
 from PortfolioProject.dbo.NashHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3 )
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2 )
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1 )
from PortfolioProject.dbo.NashHousing


ALTER TABLE NashHousing
 ADD OwnerSplitAddress nvarchar(255);

 UPDATE NashHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3 )


  ALTER TABLE NashHousing
 ADD OwnerSplitCity nvarchar(255);

 UPDATE NashHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2 )

 
  ALTER TABLE NashHousing
 ADD OwnerSplitState nvarchar(255);

 UPDATE NashHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1 )



 -- Change Y and N to Yes and No in Sold as Vacant

 select Distinct (SoldAsVacant), Count (SoldAsVacant)
 From PortfolioProject.dbo.NashHousing
 Group by SoldAsVacant
 Order by 2

 select SoldAsVacant,
  CASE when SoldAsVacant = 'Y' THEN 'yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END	  
 From PortfolioProject.dbo.NashHousing


 UPDATE NashHousing
 SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END	  
 From PortfolioProject.dbo.NashHousing


 -- Remove Duplicates

 WITH RowNumCTE AS (
 Select *,
 ROW_NUMBER () OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			        UniqueID
					) row_num

From PortfolioProject.dbo.NashHousing
--ORDER BY ParcelID
)
DELETE
From RowNumCTE
where row_num > 1
--Order by PropertyAddress


 Select *
 From PortfolioProject.dbo.NashHousing


 -- Delete Unused columns

 
 Select *
 From PortfolioProject.dbo.NashHousing

 ALTER TABLE PortfolioProject.dbo.NashHousing
 DROP COLUMN OwnerADdress, TaxDistrict, PropertyAddress

 ALTER TABLE PortfolioProject.dbo.NashHousing
 DROP COLUMN SalesDateConverted, SaleDate
