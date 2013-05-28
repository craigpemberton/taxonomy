package com.brainnoogie.taxonomy;
import java.awt.Color;
import java.awt.Dimension;
import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JComponent;
import javax.swing.JSplitPane;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import prefuse.Display;
import prefuse.Visualization;
import prefuse.action.ActionList;
import prefuse.action.RepaintAction;
import prefuse.action.assignment.ColorAction;
import prefuse.action.filter.GraphDistanceFilter;
import prefuse.action.layout.graph.ForceDirectedLayout;
import prefuse.activity.Activity;
import prefuse.controls.DragControl;
import prefuse.controls.FocusControl;
import prefuse.controls.NeighborHighlightControl;
import prefuse.controls.PanControl;
import prefuse.controls.WheelZoomControl;
import prefuse.controls.ZoomControl;
import prefuse.controls.ZoomToFitControl;
import prefuse.data.Graph;
import prefuse.data.Tuple;
import prefuse.data.event.TupleSetListener;
import prefuse.data.io.DataIOException;
import prefuse.data.io.GraphMLReader;
import prefuse.data.tuple.TupleSet;
import prefuse.render.DefaultRendererFactory;
import prefuse.render.LabelRenderer;
import prefuse.util.ColorLib;
import prefuse.util.GraphLib;
import prefuse.util.PrefuseLib;
import prefuse.util.force.ForceSimulator;
import prefuse.util.ui.JForcePanel;
import prefuse.util.ui.JPrefuseApplet;
import prefuse.util.ui.JValueSlider;
import prefuse.visual.NodeItem;
import prefuse.visual.VisualGraph;
import prefuse.visual.VisualItem;

public class Taxonomy extends JPrefuseApplet {

	@Override
	public void init(){
		this.getContentPane().add(getComponent("/socialnet.xml", "name"));
	}

	public static JComponent getComponent(String fileName, String label) {
		Graph graph = GraphLib.getBalancedTree(5, 3); 
		return getComponent(graph, label);
	}

	public static JComponent getComponent(Graph graph, String label){
		final Visualization visualization = new Visualization();
		VisualGraph visualGraph = visualization.addGraph("graph", graph);
		visualization.setValue("graph.edges", null, VisualItem.INTERACTIVE, Boolean.FALSE);
		TupleSet focusGroup = visualization.getGroup(Visualization.FOCUS_ITEMS);
		focusGroup.addTupleSetListener(new TupleSetListener(){
			public void tupleSetChanged(TupleSet ts, Tuple[] addedItems, Tuple[] removedItems){
				for(Tuple removedItem : removedItems) {
					((VisualItem)removedItem).setFixed(false);
				}
				for(Tuple addedItem : addedItems){
					((VisualItem)addedItem).setFixed(false);
					((VisualItem)addedItem).setFixed(true);
				}
				visualization.run("draw");
			}
		});
		LabelRenderer labelRenderer = new LabelRenderer(label);
		labelRenderer.setRoundedCorner(8, 8);
		visualization.setRendererFactory(new DefaultRendererFactory(labelRenderer));
		int maxhops = 4;
		int hops = 4;
		final GraphDistanceFilter filter = new GraphDistanceFilter("graph", hops);
		ActionList draw = new ActionList();
		draw.add(filter);
		draw.add(new ColorAction("graph.nodes", VisualItem.FILLCOLOR, ColorLib.rgb(200,200,255)));
		draw.add(new ColorAction("graph.nodes", VisualItem.STROKECOLOR, 0));
		draw.add(new ColorAction("graph.nodes", VisualItem.TEXTCOLOR, ColorLib.rgb(0,0,0)));
		draw.add(new ColorAction("graph.edges", VisualItem.FILLCOLOR, ColorLib.gray(200)));
		draw.add(new ColorAction("graph.edges", VisualItem.STROKECOLOR, ColorLib.gray(200)));
		ColorAction fill = new ColorAction("graph.nodes", VisualItem.FILLCOLOR, ColorLib.rgb(200,200,255));
		fill.add("_fixed", ColorLib.rgb(255,100,100));
		fill.add("_highlight", ColorLib.rgb(255,200,125));
		ForceDirectedLayout fdl = new ForceDirectedLayout("graph");
		ForceSimulator fsim = fdl.getForceSimulator();
		fsim.getForces()[0].setParameter(0, -1.2f);
		ActionList animate = new ActionList(Activity.INFINITY);
		animate.add(fdl);
		animate.add(fill);
		animate.add(new RepaintAction());
		visualization.putAction("draw", draw);
		visualization.putAction("layout", animate);
		visualization.runAfter("draw", "layout");
		Display display = new Display(visualization);
		display.setSize(500,500);
		display.setForeground(Color.GRAY);
		display.setBackground(Color.WHITE);
		display.addControlListener(new FocusControl(1));
		display.addControlListener(new DragControl());
		display.addControlListener(new PanControl());
		display.addControlListener(new ZoomControl());
		display.addControlListener(new WheelZoomControl());
		display.addControlListener(new ZoomToFitControl());
		display.addControlListener(new NeighborHighlightControl());
		display.setForeground(Color.GRAY);
		display.setBackground(Color.WHITE);
		final JForcePanel fpanel = new JForcePanel(fsim);
		final JValueSlider slider = new JValueSlider("Distance", 0, maxhops, hops);
		slider.addChangeListener(new ChangeListener(){
			public void stateChanged(ChangeEvent e){
				filter.setDistance(slider.getValue().intValue());
				visualization.run("draw");
			}
		});
		slider.setBackground(Color.WHITE);
		slider.setPreferredSize(new Dimension(300,30));
		slider.setMaximumSize(new Dimension(300,30));
		Box connectivityFilter = new Box(BoxLayout.Y_AXIS);
		connectivityFilter.add(slider);
		connectivityFilter.setBorder(BorderFactory.createTitledBorder("Connectivity Filter"));
		fpanel.add(connectivityFilter);
		fpanel.add(Box.createVerticalGlue());
		JSplitPane split = new JSplitPane();
		split.setLeftComponent(display);
		split.setRightComponent(fpanel);
		split.setOneTouchExpandable(true);
		split.setContinuousLayout(false);
		split.setDividerLocation(530);
		split.setDividerLocation(800);
		NodeItem focus =(NodeItem)visualGraph.getNode(0);
		PrefuseLib.setX(focus, null, 400);
		PrefuseLib.setY(focus, null, 250);
		focusGroup.setTuple(focus);
		return split;
	}
}
