// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstate {
    struct House {
        uint id;
        uint status; // 0: For sale, 1: Reserved, 2: Sold
        string name;
        uint price;
        string image; // Assuming image URL or IPFS hash
        string description;
        address payable seller;
        address payable buyer;
        uint reservationFee;
    }

    uint private nextId = 1;
    mapping(uint => House) public houses;

    event HouseCreated(uint houseId);
    event HouseReserved(uint houseId, address buyer);
    event HouseSold(uint houseId);
    event ReservationCancelled(uint houseId);

    modifier onlySeller(uint houseId) {
        require(houses[houseId].seller == msg.sender, "Caller is not the seller");
        _;
    }

    modifier onlyBuyer(uint houseId) {
        require(houses[houseId].buyer == msg.sender, "Caller is not the buyer");
        _;
    }

    function createHouse(string memory name, string memory image, uint price, string memory description, uint reservationFee) public {
        House memory newHouse = House({
            id: nextId,
            status: 0, // For sale
            name: name,
            price: price,
            image: image,
            description: description,
            seller: payable(msg.sender),
            buyer: payable(address(0)), // No buyer yet
            reservationFee: reservationFee
        });

        houses[nextId] = newHouse;
        emit HouseCreated(nextId);
        nextId++;
    }

    function reserveHouse(uint houseId) public payable {
        House storage house = houses[houseId];
        require(house.status == 0, "House not for sale");
        require(msg.value == house.reservationFee, "Incorrect reservation fee");
        
        house.buyer = payable(msg.sender);
        house.status = 1; // Reserved
        house.seller.transfer(msg.value); // Transfer reservation fee to seller

        emit HouseReserved(houseId, msg.sender);
    }

    function buyHouse(uint houseId) public payable onlyBuyer(houseId) {
        House storage house = houses[houseId];
        require(house.status == 1, "House not reserved");
        require(msg.value == house.price, "Incorrect price");

        house.status = 2; // Sold
        house.seller.transfer(msg.value); // Transfer the remaining amount to the seller

        emit HouseSold(houseId);
    }

    function cancelReservation(uint houseId) public onlyBuyer(houseId) {
        House storage house = houses[houseId];
        require(house.status == 1, "House not reserved");

        house.status = 0; // For sale
        house.buyer = payable(address(0)); // Reset buyer

        payable(msg.sender).transfer(house.reservationFee); // Refund reservation fee

        emit ReservationCancelled(houseId);
    }
}
