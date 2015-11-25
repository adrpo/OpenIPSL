within iPSL.Electrical.Controls.PSSE.ES.ESAC2A;
model ESAC2A "IEEE Type AC2A Excitation System"
  parameter Real T_R=0.1;
  parameter Real T_B=8;
  parameter Real T_C=19.99;
  parameter Real K_A=80;
  parameter Real T_A=0.01;
  parameter Real V_AMAX=8;
  parameter Real V_AMIN=-8;
  parameter Real K_B=25;
  parameter Real V_RMAX=15;
  parameter Real V_RMIN=-95;
  parameter Real T_E=0.2;
   parameter Real V_FEMAX=7;
   parameter Real K_H=1;
   parameter Real K_F=0.01;
   parameter Real T_F=1;
   parameter Real K_C=0.5;
   parameter Real K_D=0.35;
   parameter Real K_E=1;
   parameter Real E_1=4;
   parameter Real S_EE_1=0.4;
   parameter Real E_2=5;
   parameter Real S_EE_2=0.5;

protected
   parameter Real VREF(fixed=false);
   parameter Real Vm0(fixed=false);
   parameter Real VA0(fixed=false);
   parameter Real VFE0(fixed=false);
    parameter Real KCIFD0(fixed=false);
    parameter Real VE_0(fixed=false);

   function VE_ini
    input Real KCIFD0 "Psipp";
    input Real EFD0;
    output Real VE0;
   algorithm
    if KCIFD0 < 0 then
    VE0:=EFD0;
    elseif KCIFD0 >= 0 and KCIFD0 < 0.577*EFD0 then
    VE0:=EFD0+0.577*KCIFD0;
    elseif KCIFD0 >= 0.577*EFD0 and KCIFD0 < 1.732*EFD0 then
    VE0:=sqrt((EFD0^2+KCIFD0^2)/0.75);
    else
    VE0:=EFD0/1.732+KCIFD0;
    end if;
   end VE_ini;
public
  iPSL.NonElectrical.Continuous.LeadLag imLeadLag(
    K=1,
    T1=T_C,
    T2=T_B,
    y_start=VA0/K_A)
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  NonElectrical.Continuous.SimpleLag                        Vm(
      y_start=Vm0,
    K=1,
    T=T_R)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,4})));
  NonElectrical.Functions.ImSE
     se1(
    SE1=S_EE_1,
    SE2=S_EE_2,
    E1=E_1,
    E2=E_2)                                      annotation(Placement(transformation(extent={{-2,-2},
            {2,2}},                                                                                                 rotation = 180, origin={276,-54})));
  Modelica.Blocks.Math.Product VX annotation(Placement(transformation(extent={{-3,-3},
            {3,3}},                                                                                rotation = 180, origin={267,-51})));
  NonElectrical.Continuous.SimpleLag
                VR1(
    y_start=VA0,
    K=K_A,
    T=T_A)                                                                          annotation(Placement(transformation(extent={{34,-10},
            {54,10}})));
  Modelica.Blocks.Interfaces.RealInput ECOMP
    annotation (Placement(transformation(extent={{-134,22},{-96,60}}),
        iconTransformation(extent={{-134,22},{-96,60}})));
  Modelica.Blocks.Interfaces.RealInput VOTHSG annotation (Placement(
        transformation(extent={{-134,64},{-96,102}}),iconTransformation(extent={{-134,64},
            {-96,102}})));
  Modelica.Blocks.Sources.Constant V_REF(k=VREF)
    annotation (Placement(transformation(extent={{-86,-40},{-66,-20}})));
  Modelica.Blocks.Math.Add               imSum2_2(k1=-1, k2=1)             annotation(Placement(transformation(extent={{-4,4},{
            4,-4}},                                                                                                    rotation=0,     origin={112,6})));
  Modelica.Blocks.Math.Gain K_b(k=K_B)
                                      annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={128,6})));
  NonElectrical.Logical.HV_GATE
          hV_Gate
    annotation (Placement(transformation(extent={{144,-8},{168,26}})));
  NonElectrical.Logical.LV_GATE
          lV_Gate
    annotation (Placement(transformation(extent={{168,-14},{188,16}})));
  Modelica.Blocks.Math.Gain imGain3(k=K_H)      annotation(Placement(transformation(extent={{-4,-4},
            {4,4}},                                                                                              rotation=180,   origin={128,-40})));
  NonElectrical.Continuous.ImIntegrator_adpt
                    imIntegrator_adpt(
    nStartValue=VE_0,
    TE=T_E,
    VFEMAX=V_FEMAX,
    KD=K_D,
    KE=K_E,
    E1=E_1,
    SE1=S_EE_1,
    E2=E_2,
    SE2=S_EE_2)
             annotation (Placement(transformation(extent={{242,-10},{280,14}})));
  Modelica.Blocks.Math.Gain imGain2(k=K_E)      annotation(Placement(transformation(extent={{-3,-3},
            {3,3}},                                                                                              rotation=180,   origin={269,-65})));
  Modelica.Blocks.Math.Gain imGain4(k=K_D)      annotation(Placement(transformation(extent={{-3,-3},
            {3,3}},                                                                                              rotation=180,   origin={269,-77})));
  Modelica.Blocks.Interfaces.RealInput XADIFD annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=0,
        origin={-119,-93}), iconTransformation(extent={{-17,-17},{17,17}},
          origin={-117,-1})));
  NonElectrical.Logical.IN
     iN(       nStartValue=KCIFD0/VE_0, KC=K_C)
               annotation (Placement(transformation(
        extent={{-12,-19},{12,19}},
        rotation=90,
        origin={299,-30})));
  NonElectrical.Nonlinear.ImFEX
      fEX annotation (Placement(transformation(extent={{298,-28},{336,4}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{344,-8},{356,4}})));
  Modelica.Blocks.Interfaces.RealOutput EFD
    annotation (Placement(transformation(extent={{372,-64},{392,-44}}),
        iconTransformation(extent={{372,-64},{392,-44}})));

  Modelica.Blocks.Interfaces.RealInput EFD0
                                           annotation (Placement(transformation(
        extent={{-17,-17},{17,17}},
        rotation=90,
        origin={-61,-207}), iconTransformation(extent={{-17,-17},{17,17}},
          origin={-117,-213})));
  Modelica.Blocks.Interfaces.RealInput VOEL
                                           annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=0,
        origin={-117,-45}), iconTransformation(extent={{-17,-17},{17,17}},
          origin={-115,-43})));
  Modelica.Blocks.Interfaces.RealInput VUEL
                                           annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=0,
        origin={-117,-145}),iconTransformation(extent={{-17,-17},{17,17}},
          origin={-115,-85})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=V_AMAX, uMin=V_AMIN)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=V_RMAX, uMin=V_RMIN)
    annotation (Placement(transformation(extent={{192,-10},{212,10}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{222,-16},{242,4}})));
  NonElectrical.Continuous.DerivativeLag derivativeLag(
    K=K_F,
    T=T_F,
    y_start=0)
    annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  Modelica.Blocks.Math.Add3 add3_1(k2=-1)
    annotation (Placement(transformation(extent={{-54,-6},{-34,14}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-24,-10},{-4,10}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{258,-66},{250,-58}})));
  Modelica.Blocks.Math.Add add3
    annotation (Placement(transformation(extent={{240,-68},{232,-60}})));
initial equation
   Vm0=EFD0;
   VREF=VA0/K_A+EFD0;
   KCIFD0=K_C*XADIFD;
   VE_0=VE_ini(KCIFD0,EFD0);
  VFE0 = VE_0*(iPSL.NonElectrical.Functions.SE(
    VE_0,
    S_EE_1,
    S_EE_2,
    E_1,
    E_2) + K_E) + K_D*XADIFD;
   VA0=VFE0*(1/K_B+K_H);

equation
  connect(XADIFD, iN.IFD) annotation (Line(
      points={{-119,-93},{304,-93},{304,-36.12},{303.94,-36.12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imGain4.u, iN.IFD) annotation (Line(
      points={{272.6,-77},{304,-77},{304,-36.12},{303.94,-36.12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fEX.FEX, product.u2) annotation (Line(
      points={{329.92,-12},{342.8,-12},{342.8,-5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imIntegrator_adpt.IFD, iN.IFD) annotation (Line(
      points={{251.69,-4.12},{236,-4.12},{236,-92},{304,-92},{304,-36.12},{
          303.94,-36.12}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(product.y, EFD) annotation (Line(
      points={{356.6,-2},{380,-2},{380,-54},{382,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iN.I_N, fEX.IN) annotation (Line(
      points={{299,-24.12},{299,-12},{305.6,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imIntegrator_adpt.VE, product.u1) annotation (Line(
      points={{270.31,2},{342.8,2},{342.8,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imIntegrator_adpt.VE,VX. u2) annotation (Line(
      points={{270.31,2},{282,2},{282,-49.2},{270.6,-49.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(imSum2_2.y, K_b.u) annotation (Line(
      points={{116.4,6},{123.2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imSum2_2.u1, imGain3.y) annotation (Line(
      points={{107.2,3.6},{104,3.6},{104,-40},{123.6,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(imGain2.u, product.u1) annotation (Line(
      points={{272.6,-65},{282,-65},{282,2},{344,2},{344,1.6},{342.8,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iN.VE, product.u1) annotation (Line(
      points={{294.44,-36.12},{294.44,-64},{290,-64},{290,2},{344,2},{344,1.6},
          {342.8,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(se1.VE_IN, product.u1) annotation (Line(
      points={{278.1,-53.98},{282,-53.98},{282,2},{344,2},{344,1.6},{342.8,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(K_b.y, hV_Gate.n1) annotation (Line(
      points={{132.4,6},{140,6},{140,12.06},{147.6,12.06}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VUEL, hV_Gate.n2) annotation (Line(
      points={{-117,-145},{144.5,-145},{144.5,4.58},{147.6,4.58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hV_Gate.p, lV_Gate.n1) annotation (Line(
      points={{163.08,8.15},{166.54,8.15},{166.54,3.7},{171,3.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lV_Gate.n2, VOEL) annotation (Line(
      points={{171,-2.9},{166.5,-2.9},{166.5,-45},{-117,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VX.u1, se1.VE_OUT) annotation (Line(
      points={{270.6,-52.8},{273.3,-52.8},{273.3,-53.98},{273.9,-53.98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ECOMP, Vm.u) annotation (Line(points={{-115,41},{-90,41},{-90,4},{-86,
          4}}, color={0,0,127}));
  connect(imLeadLag.y, VR1.u)
    annotation (Line(points={{25,0},{28,0},{32,0}},
                                             color={0,0,127}));
  connect(VR1.y, limiter.u)
    annotation (Line(points={{55,0},{55,0},{68,0}}, color={0,0,127}));
  connect(limiter.y, imSum2_2.u2) annotation (Line(points={{91,0},{98,0},{98,
          8.4},{107.2,8.4}}, color={0,0,127}));
  connect(lV_Gate.p, limiter1.u) annotation (Line(points={{183.9,0.25},{186,
          0.25},{186,0},{190,0}}, color={0,0,127}));
  connect(limiter1.y, add.u1)
    annotation (Line(points={{213,0},{216.5,0},{220,0}}, color={0,0,127}));
  connect(add.u2, imGain3.u) annotation (Line(points={{220,-12},{214,-12},{214,
          -40},{132.8,-40}}, color={0,0,127}));
  connect(derivativeLag.u, imGain3.u) annotation (Line(points={{122,-70},{214,
          -70},{214,-40},{132.8,-40}}, color={0,0,127}));
  connect(Vm.y, add3_1.u2)
    annotation (Line(points={{-63,4},{-56,4}}, color={0,0,127}));
  connect(VOTHSG, add3_1.u1) annotation (Line(points={{-115,83},{-62,83},{-62,
          12},{-56,12}}, color={0,0,127}));
  connect(V_REF.y, add3_1.u3) annotation (Line(points={{-65,-30},{-60,-30},{-60,
          -4},{-56,-4}}, color={0,0,127}));
  connect(imLeadLag.u, add1.y)
    annotation (Line(points={{2,0},{-2,0},{-3,0}}, color={0,0,127}));
  connect(add3_1.y, add1.u1)
    annotation (Line(points={{-33,4},{-26,4},{-26,6}}, color={0,0,127}));
  connect(derivativeLag.y, add1.u2) annotation (Line(points={{99,-70},{36,-70},
          {-32,-70},{-32,-6},{-26,-6}}, color={0,0,127}));
  connect(imIntegrator_adpt.p1, add.y) annotation (Line(points={{251.025,1.88},
          {246,1.88},{246,-6},{243,-6}}, color={0,0,127}));
  connect(VX.y, add2.u1) annotation (Line(points={{263.7,-51},{262,-51},{262,
          -59.6},{258.8,-59.6}}, color={0,0,127}));
  connect(add2.u2, imGain2.y) annotation (Line(points={{258.8,-64.4},{262.4,
          -64.4},{262.4,-65},{265.7,-65}}, color={0,0,127}));
  connect(imGain4.y, add3.u2) annotation (Line(points={{265.7,-77},{244,-77},{
          244,-66.4},{240.8,-66.4}}, color={0,0,127}));
  connect(add3.u1, add2.y) annotation (Line(points={{240.8,-61.6},{245.4,-61.6},
          {245.4,-62},{249.6,-62}}, color={0,0,127}));
  connect(add3.y, imGain3.u) annotation (Line(points={{231.6,-64},{214,-64},{
          214,-40},{132.8,-40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -200},{300,100}}), graphics={                                                                                                    Text(extent={{
              252,-44},{280,-48}},                                                                                                lineColor=
              {0,0,255},
          textString="VX=SE*VE"),
        Text(
          extent={{210,18},{216,8}},
          lineColor={255,0,0},
          textString="VR"),
        Text(
          extent={{266,18},{272,8}},
          lineColor={255,0,0},
          textString="VE"),
        Text(
          extent={{292,-14},{298,-24}},
          lineColor={255,0,0},
          textString="I_N"),
        Text(
          extent={{314,-24},{340,-32}},
          lineColor={255,0,0},
          textString="FEX")}), Icon(coordinateSystem(extent={{-100,-200},{300,100}},
          preserveAspectRatio=true), graphics={
        Text(
          extent={{32,-2},{240,-98}},
          lineColor={0,0,255},
          textString="ESAC2A"),
        Rectangle(extent={{-98,92},{298,-222}},lineColor={0,0,255}),
        Text(
          extent={{-90,80},{-24,0}},
          lineColor={0,0,255},
          textString="ECOMP"),
        Text(
          extent={{-90,122},{-24,42}},
          lineColor={0,0,255},
          textString="VOTHSG"),
        Text(
          extent={{-88,32},{-28,-32}},
          lineColor={0,0,255},
          textString="XadIfd"),
        Text(
          extent={{-96,-198},{-32,-224}},
          lineColor={0,0,255},
          textString="EFD0"),
        Text(
          extent={{-86,-10},{-26,-74}},
          lineColor={0,0,255},
          textString="VOEL"),
        Text(
          extent={{-88,-52},{-28,-116}},
          lineColor={0,0,255},
          textString="VUEL")}),
    Documentation(info="<html>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">&LT;iPSL: iTesla Power System Library&GT;</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Copyright 2015 RTE (France), AIA (Spain), KTH (Sweden) and DTU (Denmark)</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">RTE: http://www.rte-france.com/ </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">AIA: http://www.aia.es/en/energy/</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">KTH: https://www.kth.se/en</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">DTU:http://www.dtu.dk/english</span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">The authors can be contacted by email: info at ipsl dot org</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This package is part of the iTesla Power System Library (&QUOT;iPSL&QUOT;) .</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">You should have received a copy of the GNU Lesser General Public License along with the iPSL. If not, see &LT;http://www.gnu.org/licenses/&GT;.</span></p>
</html>"));
end ESAC2A;
