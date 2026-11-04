from pathlib import Path
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE
from pptx.enum.text import PP_ALIGN

SRC = Path("slides/FIFO_AB_RTL_TO_GDSII_DEFENSE.pptx")
DST = Path("slides/FIFO_AB_RTL_TO_GDSII_DEFENSE_PHENIKAA.pptx")

assert SRC.is_file()
assert not DST.exists()

prs = Presentation(str(SRC))
assert len(prs.slides) == 15

BLUE = RGBColor(34, 55, 113)
NAVY = RGBColor(20, 42, 95)
ORANGE = RGBColor(242, 101, 34)
WHITE = RGBColor(255, 255, 255)

def remove(sh):
    el = sh._element
    el.getparent().remove(el)

def text(slide, value, x, y, w, h, size, color,
         bold=False, align=PP_ALIGN.LEFT):
    box = slide.shapes.add_textbox(
        Inches(x), Inches(y), Inches(w), Inches(h)
    )
    box.text = value
    tf = box.text_frame
    tf.word_wrap = True

    for p in tf.paragraphs:
        p.alignment = align
        for run in p.runs:
            run.font.name = "Arial"
            run.font.size = Pt(size)
            run.font.bold = bold
            run.font.color.rgb = color

    return box

def rect(slide, x, y, w, h, color):
    sh = slide.shapes.add_shape(
        MSO_SHAPE.RECTANGLE,
        Inches(x), Inches(y), Inches(w), Inches(h)
    )
    sh.fill.solid()
    sh.fill.fore_color.rgb = color
    sh.line.fill.background()

def oval(slide, x, y, w, h, color):
    sh = slide.shapes.add_shape(
        MSO_SHAPE.OVAL,
        Inches(x), Inches(y), Inches(w), Inches(h)
    )
    sh.fill.solid()
    sh.fill.fore_color.rgb = color
    sh.line.fill.background()

for number, slide in enumerate(prs.slides, 1):
    cover = number == 1

    bg = slide.background.fill
    bg.solid()
    bg.fore_color.rgb = BLUE if cover else WHITE

    for sh in list(slide.shapes):
        value = getattr(sh, "text", "")
        x = sh.left / 914400
        y = sh.top / 914400
        w = sh.width / 914400
        h = sh.height / 914400

        old_background = (
            not value and x < .2 and y < .1
            and w > 12.9 and h > 7.3
        )
        old_sidebar = (
            not value and x < .1 and y < .1
            and w < .25 and h > 7.3
        )
        old_footer_line = (
            not value and y > 6.85
            and h < .03 and w > 9
        )
        old_footer_text = (
            value.startswith("FIFO A/B  •")
            or value.strip().endswith("/ 15")
        )
        old_cover_picture = (
            cover and sh.name in (
                "Picture 12",
                "Rounded Rectangle 11"
            )
        )

        if any((
            old_background,
            old_sidebar,
            old_footer_line,
            old_footer_text,
            old_cover_picture
        )):
            remove(sh)

    if cover:
        for sh in list(slide.shapes):
            value = getattr(sh, "text", "")

            position = None

            if value.startswith("THIẾT KẾ VÀ ĐÁNH GIÁ"):
                position = (1.05, 2.25, 11.2, .7, 33)

            elif value.startswith("Đồ án tốt nghiệp"):
                position = (1.6, 3.0, 10.1, .45, 17)

            elif value.startswith("TỪ RTL ĐẾN GDSII"):
                position = (1.5, 3.8, 10.3, .55, 29)

            elif value.startswith("FIFO A: Count-based"):
                position = (2.2, 4.65, 8.9, .65, 19)

            elif value.startswith("Sinh viên:"):
                position = (2.0, 5.7, 9.4, .95, 14)

            if position:
                x, y, w, h, font_size = position
                sh.left = Inches(x)
                sh.top = Inches(y)
                sh.width = Inches(w)
                sh.height = Inches(h)

                for p in sh.text_frame.paragraphs:
                    p.alignment = PP_ALIGN.CENTER
                    for run in p.runs:
                        run.font.color.rgb = WHITE
                        run.font.size = Pt(font_size)

        text(
            slide, "PHENIKAA",
            2.58, .55, 7, .75, 53,
            WHITE, True, PP_ALIGN.CENTER
        )
        text(
            slide, "U N I V E R S I T Y",
            3.4, 1.32, 5.2, .52, 22,
            WHITE, False, PP_ALIGN.CENTER
        )

        oval(slide, 9.55, .59, 1.22, 1.22, WHITE)
        oval(slide, 9.39, .46, 1.06, 1.08, BLUE)
        oval(slide, 9.81, .54, .78, .16, ORANGE)

    else:
        for sh in slide.shapes:
            if sh.name == "TextBox 3" and getattr(sh, "text", ""):
                sh.width = Inches(9.7)
                for p in sh.text_frame.paragraphs:
                    for run in p.runs:
                        run.font.name = "Arial"
                        run.font.color.rgb = NAVY
                        run.font.bold = True
                        run.font.size = Pt(25)

        text(
            slide, "PHENIKAA",
            10.43, .20, 1.72, .31, 19,
            NAVY, True, PP_ALIGN.RIGHT
        )
        text(
            slide, "U N I V E R S I T Y",
            10.55, .54, 1.57, .18, 7,
            NAVY, False, PP_ALIGN.RIGHT
        )

        oval(slide, 12.26, .23, .52, .52, BLUE)
        oval(slide, 12.34, .16, .44, .44, WHITE)
        oval(slide, 12.49, .19, .22, .07, ORANGE)

    rect(slide, 0, 7.03, 13.333, .045, ORANGE)
    rect(slide, 0, 7.075, 13.333, .425, NAVY)

    text(
        slide, "phenikaa-uni.edu.vn",
        4.6, 7.17, 4.13, .22, 11,
        WHITE, False, PP_ALIGN.CENTER
    )
    text(
        slide, f"{number:02d} / 15",
        12.08, 7.17, .75, .22, 9,
        WHITE, False, PP_ALIGN.RIGHT
    )

prs.save(str(DST))

check = Presentation(str(DST))
assert len(check.slides) == 15

print("PHENIKAA_THEME_15_SLIDES_PASS")
print("NEW_PPTX_CREATED_PASS:", DST)
print("ORIGINAL_PPTX_PRESERVED_PASS")
print("NO_COMMIT_OR_PUSH")
