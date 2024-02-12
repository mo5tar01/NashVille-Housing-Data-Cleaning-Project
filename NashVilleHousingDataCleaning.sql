Select*
from NashVilleHousing
 
 -- standarize date formate
 Select SaleDateConverted , CONVERT(Date, SaleDate) as NewSaleDate
 from NashVilleHousing
 Update NashVilleHousing
 Set SaleDate = CONVERT(Date, SaleDate)
 Alter Table NashVilleHousing
 Add SaleDateConverted Date;

 Update NashVilleHousing
 Set SaleDateConverted = CONVERT(Date, SaleDate)

 ----------------------------------------------------------------------------------------------------------------------------------------------------------
 
 --populate property address data


Select *
From NashVilleHousing
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress , b.PropertyAddress)
From NashVilleHousing a
Join NashVilleHousing b on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress)
From NashVilleHousing a
Join NashVilleHousing b on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

 ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking address into different columns using substring


Select PropertyAddress
 From NashVilleHousing
Order by ParcelID

Select SUBSTRING(PropertyAddress,1,charindex(',', propertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,charindex(',', propertyAddress)+2 , len(propertyAddress)) as City
 From NashVilleHousing

  Alter Table NashVilleHousing
 Add PropertySplitAddress NVARCHAR(255);

 Update NashVilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',', propertyAddress)-1)
 
  Alter Table NashVilleHousing
 Add PropertySplitCity NVARCHAR(255);

 Update NashVilleHousing
 Set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',', propertyAddress)+2 , len(propertyAddress)) 

 Select PropertyAddress,PropertySplitAddress,PropertySplitCity
 from NashVilleHousing

  ----------------------------------------------------------------------------------------------------------------------------------------------------------


 -- Breaking owneraddress into different columns using substring
 Select OwnerAddress
 From NashVilleHousing

  Select
  PARSENAME(replace(ownerAddress,',','.'),1), PARSENAME(replace(ownerAddress,',','.'),2), PARSENAME(replace(ownerAddress,',','.'),3)
 From NashVilleHousing

 Alter Table NashVilleHousing
 Add OwnerSplitAddress NVARCHAR(255);

 Update NashVilleHousing
 Set OwnerSplitAddress = PARSENAME(replace(ownerAddress,',','.'),3)
 
  Alter Table NashVilleHousing
 Add OwnerSplitCity NVARCHAR(255);


 Update NashVilleHousing
 Set OwnerSplitCity = PARSENAME(replace(ownerAddress,',','.'),2)

   Alter Table NashVilleHousing
 Add OwnerSplitState NVARCHAR(255);


 Update NashVilleHousing
 Set OwnerSplitState = PARSENAME(replace(ownerAddress,',','.'),1)
 
 Select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
 From NashVilleHousing
 
 ----------------------------------------------------------------------------------------------------------------------------------------------------------

 -- Change Y and N to Yes and No in SoldAsVacant
 Select  distinct SoldAsVacant
 from NashVilleHousing
 
 Select SoldAsVacant,
 case when SoldAsVacant= 'Y' then'Yes'
  when SoldAsVacant= 'N' then'No'
  Else SoldAsVacant
  end
 from NashVilleHousing

 Update NashVilleHousing
 Set SoldAsVacant = case when SoldAsVacant= 'Y' then'Yes'
  when SoldAsVacant= 'N' then'No'
  Else SoldAsVacant
  end
 
  ----------------------------------------------------------------------------------------------------------------------------------------------------------

  -- Remove Duplicates
	  with rownumcte as(
	  Select *
	 , ROW_NUMBER() over(
	 partition by ParcelID,PROPERTYADDRESS,SalePrice,SaleDate,LegalReference
	 order by UniqueID
	 )row_num
	  From NashVilleHousing
	  )
	  	  Delete
from rownumcte
	  where row_num>1
	  SELECT*
from rownumcte
	  where row_num>1

 ----------------------------------------------------------------------------------------------------------------------------------------------------------

	  -- Delete unused columns
	  Select * 
	  from NashVilleHousing
  Alter Table NashVilleHousing
Drop column PropertyAddress
  Alter Table NashVilleHousing
Drop column OwnerAddress
  Alter Table NashVilleHousing
Drop column TaxDistrict