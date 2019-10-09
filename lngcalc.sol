pragma solidity ^ 0.5.0;

contract GasCalculator {

    event taskCompleted(string taskName);

    uint preconditions = 0x1;



    // ---------- PROCESS VARIABLES
    int gasOut;
    event DataOutput(string readingDate, int feederId, int gasLoss);
    int gasIn;
    int gasLoss;
    int feederId;
    string readingDate;
    // ----------------------------


    constructor() public {
        gasOut = -1;

        gasIn = -1;
        gasLoss = -1;
        feederId = -1;
        readingDate = "";
        Start();
    }

    function Start() public returns(bool) {
        if ((preconditions & 0x1 == 0x1)) {
            step(preconditions & uint(~0x1) | 0x4);
            emit taskCompleted("Start");
            return true;
        }
        return false;
    }


    function Input_Gas_Data(int _gasIn, int _gasOut, int _feederId, string memory _readingDate) public returns(bool) {
        if ((preconditions & 0x4 == 0x4)) {
            // ----------------------
            gasIn = _gasIn;
            gasOut = _gasOut;
            gasLoss = _gasOut - _gasIn;
            feederId = _feederId;
            readingDate = _readingDate;
            // ----------------------
            step(preconditions & uint(~0x4) | 0x2);
            emit DataOutput(readingDate, feederId, gasLoss);
            emit taskCompleted("Input_Gas_Data");
            return true;
        }
        return false;
    }


    function Success() public returns(bool) {
        if ((preconditions & 0x2 == 0x2)) {
            step(preconditions & uint(~0x2));
            emit taskCompleted("Success");
            return true;
        }
        return false;
    }


    function step(uint preconditionsp) internal {
        if (preconditionsp & 0x7 == 0) {
            preconditions = 0;
            return;
        }
        preconditions = preconditionsp;
    }

    function isProcessInstanceCompleted() view public returns(bool) {
        return getEnablement() == 0;
    }

    function bitSetter_nopredicates(uint value, uint ormask, uint mask) pure internal returns(uint) {
        if (value & mask == mask) {
            return ormask;
        }
        return 0;
    }

    function bitSetter_onlyppredicates(uint value, uint ormask, uint mask1, uint ppred) pure internal returns(uint) {
        if ((value & mask1 == mask1) && (value & ppred == ppred)) {
            return ormask;
        }
        return 0;
    }

    function bitSetter_onlynpredicates(uint value, uint ormask, uint mask, uint npred) pure internal returns(uint) {
        if ((value & mask == mask) && (value & npred == 0)) {
            return ormask;
        }
        return 0;
    }

    function bitSetter_bothpredicates(uint value, uint ormask, uint mask1, uint ppred, uint npred) pure internal returns(uint) {
        if ((value & mask1 == mask1) && (value & ppred == ppred) && (value & npred == 0)) {
            return ormask;
        }
        return 0;
    }

    function getEnablement() view public returns(uint) {
        uint enabledTasks = 0;

        // Start

        //if ( (preconditions & 0x1 == 0x1) )
        //    enabledTasks |= 0x2;
        // no predicates here
        enabledTasks |= bitSetter_nopredicates(preconditions, 0x2, 0x1);

        // Success

        //if ( (preconditions & 0x2 == 0x2) )
        //    enabledTasks |= 0x4;
        // no predicates here
        enabledTasks |= bitSetter_nopredicates(preconditions, 0x4, 0x2);

        // Input_Gas_Data

        //if ( (preconditions & 0x4 == 0x4) )
        //    enabledTasks |= 0x1;
        // no predicates here
        enabledTasks |= bitSetter_nopredicates(preconditions, 0x1, 0x4);


        return enabledTasks;
    }
    /*
// Library functions
    function uint2string(uint val) internal returns(string) {
        string memory result = new string(256);
        bytes memory result_bytes = bytes(result);
        uint i;
        for (i = 0; i < result_bytes.length; i++) {
            byte rem = (byte)((val % 10)+48);
            val = val / 10;
            result_bytes[i] = rem;
            if(val==0) {
                break;
            }
        }
        uint len = i;
        string memory out = new string(len+1);
        bytes memory out_bytes = bytes(out);
        for (i = 0; i <= len; i++) {
            out_bytes[i] = result_bytes[len-i];
        }
        return string(out_bytes);
    }
    function strConcat(string a, string b) internal returns(string) {
        return strConcat(a, b, "");
    }
    function strConcat(string a, string b, string c) internal returns(string) {
        bytes memory a_bytes = bytes(a);
        bytes memory b_bytes = bytes(b);
        bytes memory c_bytes = bytes(c);
        string memory result = new string(a_bytes.length + b_bytes.length + c_bytes.length);
        bytes memory result_bytes = bytes(result);
        uint i;
        uint pos = 0;
        for (i = 0; i < a_bytes.length; i++) result_bytes[pos++] = a_bytes[i];
        for (i = 0; i < b_bytes.length; i++) result_bytes[pos++] = b_bytes[i];
        for (i = 0; i < c_bytes.length; i++) result_bytes[pos++] = c_bytes[i];
        return string(result_bytes);
    }
*/
    // -------
}
