Select *
From PortProject.dbo.Sheet1$

--Date Formatting
Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortProject.dbo.Sheet1$


Update Sheet1$
SET SaleDate = CONVERT(Date,SaleDate)

--Property
Select *
From PortProject.dbo.Sheet1$
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortProject.dbo.Sheet1$ a
JOIN PortProject.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortProject.dbo.Sheet1$ a
JOIN PortProject.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From PortProject.dbo.Sheet1$

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortProject.dbo.Sheet1$


Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From PortProject.dbo.Sheet1$





Select OwnerAddress
From PortProject.dbo.Sheet1$


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortProject.dbo.Sheet1$

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

--ALTER TABLE Sheet1$
--Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

--ALTER TABLE Sheet1$
--Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortProject.dbo.Sheet1$
----------------------------------------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortProject.dbo.Sheet1$
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortProject.dbo.Sheet1$


Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
------------------------

WITH RowNumCTE AS(
Select* , 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
	From PortProject.dbo.Sheet1$)

	Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortProject.dbo.Sheet1$


--ALTER TABLE PortProject.dbo.Sheet1$
--DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


