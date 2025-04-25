function coax_visualizer(geom, material, operating)

    %used below stack overflow page to plot circles
    %https://stackoverflow.com/questions/29194004/how-to-plot-a-circle-in-matlab
    
    %assign plotting colors for conductor and dielectric
    conductor_color = [0,0,0];
    dielectric_color = [1,1,1];
    
    %distance value for spacing figure
    delta = .2*geom.b;
    
    %radii of circles to plot coax
    r1 = geom.b+delta;
    r2 = geom.b;
    r3 = geom.a;
    
    %variable to discretize time
    n = 1000;
    
    %time variable
    t = linspace(0,2*pi,n);
    
    %outer most circle
    x1 =  r1*sin(t);
    y1 =  r1*cos(t);
    
    %plot outer most circle
    line(x1,y1)
    fill(x1,y1,conductor_color)
    hold on;
   
    %middle circle
    x2 = r2*sin(t);
    y2 = r2*cos(t);
    
    %plot middle circle
    line(x2,y2)
    fill(x2,y2,dielectric_color)
    
    %inner most circle
    x3 = r3*sin(t);
    y3 = r3*cos(t);
    
    %plot inner circle
    line(x3,y3)
    fill(x3,y3,conductor_color)
    
    %plot larger diameter dimension line
    vertx1 = linspace(geom.b+delta*5,geom.b+delta*5,10);
    verty1 = linspace(-geom.b,geom.b,10);
    line(vertx1,verty1,"Color",'k')
  
    %dimension bars
    horz1x = linspace(geom.b+delta*4,geom.b+delta*6,10);
    horz1uy = linspace(geom.b,geom.b,10);
    horz1dy = linspace(-geom.b,-geom.b,10);
    line(horz1x,horz1uy,"Color",'k')
    line(horz1x,horz1dy,"Color",'k')

    %inner circle diameter dimension line
    vertx2 = linspace(geom.b+delta*3,geom.b+delta*3,10);
    verty2 = linspace(-geom.a,geom.a,10);
    line(vertx2,verty2,"Color",'k')
    
    %dimension bars
    horz1x = linspace(geom.b+delta*2,geom.b+delta*4,10);
    horz1uy = linspace(geom.a,geom.a,10);
    horz1dy = linspace(-geom.a,-geom.a,10);
    line(horz1x,horz1uy,"Color",'k')
    line(horz1x,horz1dy,"Color",'k')

    axis equal
    set(gca,'visible','off')
    
    %text for dimensions
    text(geom.b+2.5*delta, geom.a+delta, ["in. diam = ", num2str(geom.a)])
    text(geom.b+4.5*delta, geom.b+delta, ["out diam = ", num2str(geom.b)])
    
    %text for relative perm.
    text(-geom.a-2*delta, 0, ["\epsilon = ", num2str(material.er)],"FontSize", 12)
    
    %title
    text(0, geom.b+2*delta, "Coax Visualizer", "FontSize", 15)

    