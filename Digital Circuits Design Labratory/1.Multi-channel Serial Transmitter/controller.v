module controller (
    input serin,
    input clk,
    input clk_en,
    input rst,
    input co1,
    input co2,
    input coD,
    output reg cnt1,
    output reg cnt2,
    output reg cntD,
    output reg ldcntD,
    output reg sh_enD,
    output reg sh_enP,
    output reg SerOutValid,
    output reg done
);

    parameter [2:0] Idle = 3'd0,
                    GetPortNum = 3'd1,
                    GetDataNum = 3'd2,
                    ld_DT = 3'd3,
                    CountData = 3'd4;
    reg [2:0] ps, ns;

    always @(ps, serin, co1, co2, coD) begin
        case (ps)
            Idle:       ns = serin ? Idle : GetPortNum;
            GetPortNum: ns = co1 ? GetDataNum : GetPortNum;
            GetDataNum: ns = co2 ? ld_DT : GetDataNum;
            ld_DT:      ns = CountData;
            CountData:  ns = coD ? Idle : CountData; 
            default:    ns = Idle;
        endcase
    end

    always @(ps, coD) begin
        {cnt1, cnt2, cntD, ldcntD, sh_enD, sh_enP, SerOutValid, done} = 8'b0;
        case (ps)
            GetPortNum: {sh_enP, cnt1} = 2'b11;
            GetDataNum: {sh_enD, cnt2} = 2'b11;
            ld_DT: {ldcntD, SerOutValid} = 2'b11;
            CountData: {cntD, SerOutValid, done} = {2'b11, coD};
            default: {cnt1, cnt2, cntD, ldcntD, sh_enD, sh_enP, SerOutValid, done} = 8'b0;
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= Idle;
        else if (clk_en)
            ps <= ns;
    end
    
endmodule