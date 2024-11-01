// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Graph} from "../src/Graph.sol";
import {console} from "forge-std/console.sol";

contract GraphTest is Test {
    Graph public graph;

    function setUp() public {
        graph = new Graph();
    }

    function test_1() public {
        graph.addEdge(1, 2);
        graph.addEdge(2, 3);
        graph.addEdge(3, 4);
        uint256[] memory expected = new uint256[](4);
        expected[0] = 1;
        expected[1] = 2;
        expected[2] = 3;
        expected[3] = 4;
        assertEq(graph.findShortestRouteBetweenTwoNodes(1, 4), expected);
    }

    /**
     * #! mermaid
     *  graph TD
     *  1 --> 2
     *  2 --> 3
     *  2 --> 4
     *  2 --> 5
     *  4 --> 5
     */
    function test_2() public {
        graph.addEdge(1, 2);
        graph.addEdge(2, 3);
        graph.addEdge(2, 4);
        graph.addEdge(2, 5);
        graph.addEdge(4, 5);

        uint256[] memory expected = new uint256[](3);
        expected[0] = 1;
        expected[1] = 2;
        expected[2] = 4;
        assertEq(graph.findShortestRouteBetweenTwoNodes(1, 4), expected);
    }

    /**
     * #! mermaid
     *     graph TD
     *     1--> 2
     *     2--> 3
     *     3--> 10
     *     4--> 3
     *     4--> 5
     *     5--> 6
     *     6--> 2
     *     6--> 7
     *     7--> 4
     *     7--> 5
     *     2--> 8
     *     8--> 3
     *     3--> 9
     *     9--> 4
     *     5--> 10
     *     10--> 6
     *     6--> 11
     *     11--> 7
     */
    function test_3() public {
        graph.addEdge(1, 2);
        graph.addEdge(2, 3);
        graph.addEdge(2, 6);
        graph.addEdge(3, 10);
        graph.addEdge(4, 3);
        graph.addEdge(4, 5);
        graph.addEdge(5, 6);
        graph.addEdge(6, 2);
        graph.addEdge(6, 7);
        graph.addEdge(7, 4);
        graph.addEdge(7, 5);
        graph.addEdge(2, 8);
        graph.addEdge(8, 3);
        graph.addEdge(3, 9);
        graph.addEdge(9, 4);
        graph.addEdge(5, 10);
        graph.addEdge(10, 6);
        graph.addEdge(6, 11);
        graph.addEdge(11, 7);

        uint256[] memory expected = new uint256[](4);
        expected[0] = 1;
        expected[1] = 2;
        expected[2] = 6;
        expected[3] = 7;

        assertEq(graph.findShortestRouteBetweenTwoNodes(1, 7), expected);
    }

    /**
     * Test cyclic graph
     */
    function test_4() public {
        graph.addEdge(1, 2);
        graph.addEdge(2, 3);
        graph.addEdge(3, 3);

        vm.expectRevert();
        graph.findShortestRouteBetweenTwoNodes(1, 4);
    }
}
