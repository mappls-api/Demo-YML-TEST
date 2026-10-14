import sys, re, pathlib, tempfile
sys.path.insert(0, "scripts")
import update_sdk_docs as u

readme_text = pathlib.Path("README.md").read_text()
lines = readme_text.splitlines()
row = next((l for l in lines if re.match(r"^\s*\|\s*\[(\d+(?:\.\d+){1,3})\]", l)), "")
m = re.match(r"^\s*\|\s*\[(\d+(?:\.\d+){1,3})\]", row)
label = m.group(1) if m else None
folder = re.search(r"docs/(v\d+\.\d+\.\d+)/README", row)
print("newest README row label:", label)
print("row links to folder    :", folder.group(1) if folder else None)
print("raster currently        :",
      (re.search(r"MapplsRasterCatalogue - [\d.]+", row) or ["<none>"])[0]
      if isinstance(re.search(r"MapplsRasterCatalogue - [\d.]+", row), re.Match)
      else "<not found>")

# Test the writer against the real README using the row's own label version.
tmp = pathlib.Path(tempfile.mkdtemp()) / "README.md"
tmp.write_text(readme_text)
changed = u.update_readme_versions(tmp, "v" + label,
                                   {"RasterCatalouge": "1.0.1"}, dry_run=False)
newrow = next((l for l in tmp.read_text().splitlines()
               if "MapplsRasterCatalogue" in l), "")
hit = re.search(r"MapplsRasterCatalogue - [\d.]+", newrow)
print("changed                 :", changed)
print("raster after            :", hit.group(0) if hit else "<not found>")
