select *
from project_2.dbo.nashville_housing$;

--- standardize data format

select SaleDate, CONVERT(Date,SaleDate)
from project_2.dbo.nashville_housing$


update project_2.dbo.nashville_housing$
SET SaleDate = CONVERT(Date,SaleDate)

select SaleDate
from project_2.dbo.nashville_housing$

-- alter way 
ALTER TABLE project_2.dbo.nashville_housing$
Add SaleDateConverted Date;

Update project_2.dbo.nashville_housing$
SET SaleDateConverted = CONVERT(Date,SaleDate)


---populate property address data

select *
from project_2.dbo.nashville_housing$
--where Property_Address is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.propertyaddress)
from project_2.dbo.nashville_housing$ a
JOIN project_2.dbo.nashville_housing$ b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID 
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from project_2.dbo.nashville_housing$ a
JOIN project_2.dbo.nashville_housing$ b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select *
from project_2.dbo.nashville_housing$

--breaking address in to their own columns

select PropertyAddress
from project_2.dbo.nashville_housing$
--where Property_Address is null
--order by parcal_id

select
substring(PropertyAddress, 1, CHARINDEX(',', Propertyaddress -1)) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from project_2.dbo.nashville_housing$



ALTER TABLE project_2.dbo.nashville_housing$
ADD propertySplitAddress Nvarchar(255)

update project_2.dbo.nashville_housing$
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE project_2.dbo.nashville_housing$
ADD propertySplitcity Nvarchar(255);

update project_2.dbo.nashville_housing$
Set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))

select *
from project_2.dbo.nashville_housing$

--

select OwnerAddress
from project_2.dbo.nashville_housing$

select
PARSENAME(replace(OwnerAddress , ',' , '.'),3)
,PARSENAME(replace(OwnerAddress , ',' , '.'),2)
,PARSENAME(replace(OwnerAddress , ',' , '.'),1)
From  project_2.dbo.nashville_housing$

ALTER TABLE project_2.dbo.nashville_housing$
ADD OwnerSplitAddress Nvarchar(255)

update project_2.dbo.nashville_housing$
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress , ',' , '.'),3)


ALTER TABLE project_2.dbo.nashville_housing$
ADD OwnerSplitcity Nvarchar(255);

update project_2.dbo.nashville_housing$
Set OwnerSplitcity = PARSENAME(replace(OwnerAddress , ',' , '.'),2)

ALTER TABLE project_2.dbo.nashville_housing$
ADD OwnerSplitState Nvarchar(255)

update project_2.dbo.nashville_housing$
Set OwnerSplitState = PARSENAME(replace(OwnerAddress , ',' , '.'),1)

select *
from project_2.dbo.nashville_housing$

----change y and n to yes and no in SoldAsVacant column

select distinct(SoldAsvacant), count(SoldAsvacant)
from project_2.dbo.nashville_housing$
group by SoldAsvacant
order by 2


select SoldAsvacant
,case when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  end
from project_2.dbo.nashville_housing$

update project_2.dbo.nashville_housing$
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  end


-- removing duplicate

select *
from project_2.dbo.nashville_housing$

with RownumCTE as(
select *,
  ROW_NUMBER() over(
  partition by ParcelID,
              PropertyAddress,
			  Saleprice,
			  SaleDate,
			  LegalReference
			  order by UniqueID
			  ) row_num

from project_2.dbo.nashville_housing$
)

select *
from RownumCTE
where row_num > 1
--order by PropertyAddress



-- deleting unused columns

select *
from project_2.dbo.nashville_housing$

alter table project_2.dbo.nashville_housing$
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate




			  






