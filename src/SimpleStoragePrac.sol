//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

/**
 * @title store and retrieve fav num of users based on username
 * @author Chakradhar Kolipaka
 */

contract SimpleStoragePrac {
    error SimpleStoragePrac__EmptyName();
    error SimpleStoragePrac__NotFound();
    error SimpleStoragePrac__NameExists();

    struct User {
        string name;
        uint256 fav;
    }
    User[] public users; //dynamic arr
    mapping(string => uint256) public nameToFavNum; //user -> fav
    mapping(string => uint256) /*private*/ public nameIndex; //user -> idx

    event PersonAdded(string name, uint256 fav);
    event PersonUpdated(string name, uint256 fav);
    event PersonRemoved(string name);

    function addPerson(string memory _uname, uint256 _fav) public {
        if (bytes(_uname).length == 0) revert SimpleStoragePrac__EmptyName();
        if (nameIndex[_uname] != 0) revert SimpleStoragePrac__NameExists();

        users.push(User(_uname, _fav));
        nameToFavNum[_uname] = _fav;
        nameIndex[_uname] = users.length; //1-based indexing

        emit PersonAdded(_uname, _fav);
    }

    function retrieveFavByName(
        string calldata _uname
    ) public view returns (uint256) {
        if (bytes(_uname).length == 0) revert SimpleStoragePrac__EmptyName();
        return nameToFavNum[_uname];
    }

    function listOfMembers()
        public
        view
        returns (uint256 count, User[] memory)
    {
        return (users.length, users);
    }

    function modify(string calldata _uname, uint256 _fav) public {
        if (bytes(_uname).length == 0) revert SimpleStoragePrac__EmptyName();
        uint256 idxPlus1 = nameIndex[_uname];
        if (idxPlus1 == 0) revert SimpleStoragePrac__NotFound();

        uint256 idx = idxPlus1 - 1;
        users[idx].fav = _fav;
        nameToFavNum[_uname] = _fav;

        emit PersonUpdated(_uname, _fav);
    }

    function remove(string calldata _uname) public {
        if (bytes(_uname).length == 0) revert SimpleStoragePrac__EmptyName();
        uint256 idxPlus1 = nameIndex[_uname];
        if (idxPlus1 == 0) revert SimpleStoragePrac__NotFound();
        uint256 idx = idxPlus1 - 1;
        uint256 lastIdx = users.length - 1;

        if (idx != lastIdx) {
            User memory moved = users[lastIdx];
            users[idx] = moved;
            nameIndex[moved.name] = idx + 1;
        }

        users.pop();
        delete nameToFavNum[_uname];
        delete nameIndex[_uname];

        emit PersonRemoved(_uname);
    }

    //getters
    function nameToFavNumValues(
        string calldata _uname
    ) public view returns (uint256 fav) {
        return nameToFavNum[_uname];
    }

    function nameIndexIdx(string calldata _uname) public view returns (uint256 idx) {
        return nameIndex[_uname];
    }
}
