// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";

contract Graph {
    // List of Nodes and their neighbors, aka the graph (cyclic and non directed)
    mapping(uint256 => uint256[]) public nodes;

    mapping(uint256 => bool) public visited;

    uint256[] path;
    uint256[][] queue;

    function addEdge(uint256 from, uint256 to) public {
        nodes[from].push(to);
    }

    function findShortestRouteBetweenTwoNodes(uint256 start, uint256 end) public returns (uint256[] memory) {
        // Clear arrays
        delete queue;
        delete path;

        queue.push([start]);

        while (queue.length > 0) {
            path = queue[0];
            uint256 current = path[path.length - 1];

            if (!visited[current]) {
                visited[current] = true;
                for (uint256 i = 0; i < nodes[current].length; i++) {
                    uint256 nextNode = nodes[current][i];

                    uint256[] memory newPath = new uint256[](path.length + 1);
                    for (uint256 j = 0; j < path.length; j++) {
                        newPath[j] = path[j];
                    }
                    newPath[path.length] = nextNode;

                    queue.push(newPath);

                    if (nextNode == end) {
                        path.push(nextNode);
                        return path;
                    }
                }
            }

            // Doing an unshift, instead of a pop
            for (uint256 i = 0; i < queue.length - 1; i++) {
                queue[i] = queue[i + 1];
            }
            queue.pop();
        }

        // Path not found
        revert("No path found");
    }
}
