// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Graph {
    // List of Nodes and their neighbors, aka the graph (cyclic and non directed)
    mapping(uint256 => uint256[]) nodes;

    uint256[] visited;
    uint256[][] queue;

    // Add a Node, w/o consistency check
    function addEdge(uint256 from, uint256 to) public {
        nodes[from].push(to);
    }

    // Get the shortest path between two nodes
    function findShortestRouteBetweenTwoNodes(uint256 start, uint256 end) public returns (uint256[] memory) {
        bool isVisited;

        // Clear arrays
        delete queue;
        delete visited;

        queue.push([start]);

        while (queue.length > 0) {
            uint256[] memory path = queue[0];
            uint256 current = path[path.length - 1];

            isVisited = false;
            for (uint256 i = 0; i < visited.length; i++) {
                if (visited[i] == current) {
                    isVisited = true;
                    break;
                }
            }

            if (!isVisited) {
                visited.push(current);
                for (uint256 i = 0; i < nodes[current].length; i++) {
                    uint256[] memory newPath = new uint256[](path.length + 1);
                    for (uint256 j = 0; j < path.length; j++) {
                        newPath[j] = path[j];
                    }
                    newPath[path.length] = nodes[current][i];
                    queue.push(newPath);

                    if (nodes[current][i] == end) {
                        return newPath;
                    }
                }
            }
            queue.pop();
        }

        // Path not found
        revert("No path found");
    }
}
