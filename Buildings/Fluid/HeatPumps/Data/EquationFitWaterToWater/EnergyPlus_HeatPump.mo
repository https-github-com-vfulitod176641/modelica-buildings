within Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater;
record EnergyPlus_HeatPump =
 Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic_EquationFit (
    TRefHeaCon=55 + 273.15,
    TRefHeaEva=14 + 273.15,
    TRefCooCon=35 + 273.15,
    TRefCooEva=8 + 273.15,
    QCon_heatflow_nominal=39040.00,
    QEva_heatflow_nominal=-39890.91,
    VCon_nominal=0.001893,
    mCon_flow_nominal=1.9,
    VEva_nominal=0.001893,
    mEva_flow_nominal=1.9,
    PCon_nominal_HD=2800,
    PEva_nominal_CD=2300,
    HLRC={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
    CLRC={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
    PHC={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378},
    PCC={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665})
      "EnergyPlus_HeatPumpEnergyPlus_HeatPump"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="EPdataHP",
  defaultComponentPrefixes="parameter",
  Documentation(info= "<html>
This data corresponds to the EnergyPlus example file <code>GSHPSimple-GLHE.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and
nominal heating capacity of <i>39040</i> Watt.
</html>"));