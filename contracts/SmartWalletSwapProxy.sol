// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;

import "@openzeppelin/contracts/utils/Address.sol";
import "./SmartWalletSwapStorage.sol";

contract SmartWalletSwapProxy is SmartWalletSwapStorage {
    using Address for address;

    event ImplementationUpdated(address indexed implementation);

    constructor(
        address _admin,
        address _implementation,
        IPancakeRouter02[] memory _routers
    ) SmartWalletSwapStorage(_admin) {
        _setImplementation(_implementation);
        for (uint256 i = 0; i < _routers.length; i++) {
            pancakeRouters[_routers[i]] = true;
        }
    }

    function updateNewImplementation(address _implementation) external onlyAdmin {
        _setImplementation(_implementation);
        emit ImplementationUpdated(_implementation);
    }

    receive() external payable {}

    /**
     * @dev Delegates execution to an implementation contract.
     * It returns to the external caller whatever the implementation returns
     * or forwards reverts.
     */
    fallback() external payable {
        (bool success, ) = implementation().delegatecall(msg.data);

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize())
            switch success
                case 0 {
                    revert(free_mem_ptr, returndatasize())
                }
                default {
                    return(free_mem_ptr, returndatasize())
                }
        }
    }

    function implementation() public view returns (address impl) {
        bytes32 slot = IMPLEMENTATION;
        assembly {
            impl := sload(slot)
        }
    }

    function _setImplementation(address _implementation) internal {
        require(_implementation.isContract(), "non-contract address");

        bytes32 slot = IMPLEMENTATION;
        assembly {
            sstore(slot, _implementation)
        }
    }
}
