# RENTAL.SOL

# Auto-generated documentation for the house workflow
This workflow handles 'House' objects and is part of the 'Buy real estate with reservation d0011e33' project.

## Properties
The object has the following properties:

* `Id` (Integer)
* `Status` (Integer)
* `Name` (String)
* `Price` (Money)
* `Image` (Image)
* `Description` (String)
* `Seller` (Address)
* `Buyer` (Address)
* `Reservation fee` (Money)

## States
The workflow includes 3 states:

* For sale
* Reserved
* Sold

## Transitions
### <a name="tran_create"></a>
Transition: 'Create'
This transition creates a new object and puts it into `For sale` state.

#### Transition Parameters
For this transition, the following parameters are required: 

* `Name` (Text)
* `Image` (Image)
* `Price` (Money)
* `Description` (Text)
* `Reservation fee` (Money)

#### Access Restrictions
Access is specifically restricted to the user with the address from the `Seller` property. If `Seller` property is not yet set then the method caller becomes the objects `Seller`.

#### Checks and updates
The following properties will be updated on blockchain:

* `Name` (String)
* `Image` (Image)
* `Price` (Money)
* `Description` (String)
* `Reservation fee` (Money)


---
### <a name="tran_reserve"></a>
Transition: 'Reserve'
This transition begins from `For sale` and leads to the state `Reserved`.

#### Access Restrictions
Access is specifically restricted to the user with the address from the `Buyer` property. If `Buyer` property is not yet set then the method caller becomes the objects `Buyer`.

#### Payment Process
In the end a payment is made.
A payment in the amount of `Reservation fee` is made from caller to the address specified in the `Seller` property.


---
### <a name="tran_cancel"></a>
Transition: 'Cancel'
This transition begins from `Reserved` and leads to the state `For sale`.

#### Access Restrictions
Access is specifically restricted to the user with the address from the `Buyer` property. If `Buyer` property is not yet set then the method caller becomes the objects `Buyer`.


---
### <a name="tran_buy"></a>
Transition: 'Buy'
This transition begins from `Reserved` and leads to the state `Sold`.

#### Payment Process
In the end a payment is made.
A payment in the amount of `Price` is made from caller to the address specified in the `Seller` property.


---
