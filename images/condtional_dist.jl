using Gadfly, DataFrames, NPZ, PyCall, Transducers, Query, Statistics
import Cairo, Fontconfig
@pyimport torch

function plot_joint(idx1, idx2, X, g)
    X1 = X[:, idx1]
    X2 = X[:, idx2]
    t1 = g[:, idx1]
    t2 = g[:, idx2]
    if idx1 == idx2
        return plot()
    end
    df = DataFrame(mask_value_1 = X1, mask_value_2 = X2)
    plot(df, x=:mask_value_1, y=:mask_value_2, Geom.density2d, Scale.color_continuous, Guide.colorkey(title="density"), Coord.Cartesian(xmin=0, xmax=1, ymin=0, ymax=1), Guide.title("Joint Distribution for (v[$(t1[1]+1)], v[$(t1[2]+1)]) and (v[$(t2[1]+1)], v[$(t2[2]+1)])"))
end

function plot_dist(dist, gt_idx, g)
    joint_idx = Iterators.product(gt_idx, gt_idx) |> collect
    plts = map(t -> plot_joint(t[1], t[2], dist, g), joint_idx)
    gridstack(plts)
end

function plot_joint_df(dist)
    cols = names(dist)
    plts = Vector{Plot}()
    for (c1, c2) ∈ Iterators.product(cols, cols)
        if c1==c2
            push!(plts, plot())
        else
            push!(plts, plot(dist, x=Symbol(c1), y=Symbol(c2), Geom.density2d, Scale.color_continuous, Guide.colorkey(title="density"), Coord.Cartesian(xmin=0, xmax=1, ymin=0, ymax=1), Guide.title("Joint Distribution for $(c1) and $(c2)")))
        end
    end
    plts = reshape(plts, length(cols), length(cols))
    gridstack(plts)
end

function plot_marginal(idx, X, g)
    df = DataFrame(mask_value = X[:, idx])
    t = g[:, idx]
    plot(df, x=:mask_value, Geom.density, Coord.Cartesian(xmin=0, xmax=1), Guide.title("Marginal Edge Weight Distribution for (v[$(t[1]+1)], v[$(t[2]+1)])"))
end

function plot_cor(df)
    cols = names(df)
    c1s = String[]
    c2s = String[]
    cors = Float64[]    
    for (c1, c2) ∈ Iterators.product(cols, cols)
        push!(c1s, c1)
        push!(c2s, c2)
        push!(cors, cor(df[!, c1], df[!, c2]))
    end
    plot(DataFrame(edge₁=c1s, edge₂=c2s, cor=cors), x=:edge₁, y=:edge₂, color=:cor, Geom.rectbin)
end

g = torch.load("/Users/shalinpatel/Documents/Brown/Research/Singh Lab/GCN-Integration/scripts/BI/pyro_model/experiments/tree/comp_graph.pt").numpy()
gt = torch.load("/Users/shalinpatel/Documents/Brown/Research/Singh Lab/GCN-Integration/scripts/BI/pyro_model/experiments/tree/gt_grn.pt").numpy()
gt_idx = map(e -> findfirst(map(t -> e == t, eachslice(g, dims=2))), eachslice(gt, dims=2))

dist = npzread("/Users/shalinpatel/Documents/Brown/Research/Singh Lab/GCN-Integration/scripts/BI/pyro_model/experiments/tree/example_dnfg_dist_1.npy")
plts = map(i -> plot_marginal(i, dist, g), gt_idx)
plts = reshape(plts, (2, 4))
gridstack(plts)
plot_dist(dist, gt_idx, g)

edge_names = map(t->"Edge: $(t[1]+1), $(t[2]+1)", eachslice(gt, dims=2))
df = DataFrame([n=>dist[:, gt_idx[i]] for (i, n) ∈ enumerate(edge_names)])
plot_cor(df) |> PDF("tree-model-dnfg-cor.pdf", 10inch, 10inch)
