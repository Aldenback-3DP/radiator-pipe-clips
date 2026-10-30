# Radiator Pipe Clips

A parametric **double / twin radiator pipe clip** for OpenSCAD: a back plate with two snap-on C-clips that hold the supply and return pipes of a radiator at a fixed distance from the wall. Optional **stackable spacers** move the clip further out from the wall.

> ⚠️ **Not test-printed yet.** The dimensions are derived from the parameters below, but the parts have not been printed and fitted. Print one clip first and check the snap fit before printing a batch.

## Previews

| 15 mm | 18 mm | 22 mm |
|---|---|---|
| ![15 mm clip](images/twin_pipe_clip_15mm.png) | ![18 mm clip](images/twin_pipe_clip_18mm.png) | ![22 mm clip](images/twin_pipe_clip_22mm.png) |

| Spacer 2.5 mm | Spacer 5 mm |
|---|---|
| ![2.5 mm spacer](images/spacer_2.5mm.png) | ![5 mm spacer](images/spacer_5mm.png) |

## STL files

| File | Part | Pipe Ø | Notes |
|---|---|---|---|
| [stl/twin_pipe_clip_15mm.stl](stl/twin_pipe_clip_15mm.stl) | Twin clip | 15 mm | c/c 40 mm, gap 20 mm |
| [stl/twin_pipe_clip_18mm.stl](stl/twin_pipe_clip_18mm.stl) | Twin clip | 18 mm | c/c 40 mm, gap 20 mm |
| [stl/twin_pipe_clip_22mm.stl](stl/twin_pipe_clip_22mm.stl) | Twin clip | 22 mm | c/c 40 mm, gap 20 mm |
| [stl/spacer_2.5mm.stl](stl/spacer_2.5mm.stl) | Spacer | any | 2.5 mm thick, stackable |
| [stl/spacer_5mm.stl](stl/spacer_5mm.stl) | Spacer | any | 5 mm thick, stackable |

## Parameters

All parameters are at the top of [`src/radiator_pipe_clip.scad`](src/radiator_pipe_clip.scad) (comments in the file are in Swedish).

| Parameter | Default | Meaning |
|---|---|---|
| `part` | `"holder"` | `"holder"` for the twin clip, `"spacer"` for a spacer |
| `pipe_d1` | `18` | Diameter of pipe 1 (mm) |
| `pipe_d2` | `18` | Diameter of pipe 2 (mm), can differ from pipe 1 |
| `cc` | `40` | Centre-to-centre distance between the pipes (mm) |
| `gap` | `20` | Distance from the wall to the nearest pipe surface (mm), without spacers |
| `clearance` | `0.3` | Radial play around the pipe (mm) |
| `snap_ratio` | `0.87` | Clip opening width / pipe diameter (lower = tighter snap) |
| `clip_wall` | `2.6` | Wall thickness of the C-clips (mm, tuned for PETG) |
| `width` | `14` | Clip width along the pipe = print height (mm) |
| `base_t` | `4` | Back plate thickness (mm) |
| `base_len` | `60` | Back plate length (mm) |
| `screw_d` / `screw_head_d` | `4.2` / `8.5` | Screw hole and countersink diameter (mm) |
| `spacer_t` | `5` | Spacer thickness (mm), e.g. 2.5 or 5 |
| `spacer_len` | `60` | Spacer length (mm), independent of pipe size |
| `peg_x`, `peg_d`, `peg_h`, `peg_tol`, `pegs` | `24`, `4`, `2`, `0.25`, `true` | Locating pegs; fixed positions so one spacer fits every clip |

### Spacers are stackable

Spacers have locating pegs at fixed positions, so they fit every clip size and stack on each other. Combine 2.5 mm and 5 mm spacers to fine-tune the wall distance (e.g. 2.5 + 5 = 7.5 mm extra).

### Standard copper pipe sizes

Copper pipe (EN 1057) is commonly 10, 12, 15, 18, 22 and 28 mm outer diameter. Set `pipe_d1` / `pipe_d2` to the measured outer diameter of your pipes.

## Customizing in OpenSCAD

1. Install [OpenSCAD](https://openscad.org/).
2. Open `src/radiator_pipe_clip.scad`.
3. Edit the parameters at the top of the file, or use **Window → Customizer**.
4. Press **F6** to render, then **File → Export → Export as STL**.

From the command line:

```sh
# 22 mm twin clip
openscad -o clip_22.stl -D pipe_d1=22 -D pipe_d2=22 src/radiator_pipe_clip.scad
# 15 mm + 18 mm mixed clip, pipes 45 mm apart
openscad -o clip_15_18.stl -D pipe_d1=15 -D pipe_d2=18 -D cc=45 src/radiator_pipe_clip.scad
# 2.5 mm spacer
openscad -o spacer_2.5.stl -D 'part="spacer"' -D spacer_t=2.5 src/radiator_pipe_clip.scad
```

## Print tips

- **Material:** PETG (tough and slightly flexible, good for snap fits and warm pipes).
- **Perimeters:** 4 walls for strong clip arms.
- **Orientation:** print flat as exported, **no supports** needed.
