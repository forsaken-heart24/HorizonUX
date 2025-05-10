.class Lde/dylt/yanndroid/screenresolution/MainActivity$3;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Lcom/google/android/material/appbar/AppBarLayout$OnOffsetChangedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lde/dylt/yanndroid/screenresolution/MainActivity;->initToolbar()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

.field final synthetic val$AppBar:Lcom/google/android/material/appbar/AppBarLayout;

.field final synthetic val$collapsed_title:Landroid/widget/TextView;

.field final synthetic val$expanded_title:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Lde/dylt/yanndroid/screenresolution/MainActivity;Lcom/google/android/material/appbar/AppBarLayout;Landroid/widget/TextView;Landroid/widget/TextView;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010,
            0x1010
        }
        names = {
            "this$0",
            "val$AppBar",
            "val$expanded_title",
            "val$collapsed_title"
        }
    .end annotation

    .line 227
    iput-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->this$0:Lde/dylt/yanndroid/screenresolution/MainActivity;

    iput-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$AppBar:Lcom/google/android/material/appbar/AppBarLayout;

    iput-object p3, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$expanded_title:Landroid/widget/TextView;

    iput-object p4, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$collapsed_title:Landroid/widget/TextView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onOffsetChanged(Lcom/google/android/material/appbar/AppBarLayout;I)V
    .locals 3
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x0,
            0x0
        }
        names = {
            "appBarLayout",
            "verticalOffset"
        }
    .end annotation

    .line 230
    iget-object p1, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$AppBar:Lcom/google/android/material/appbar/AppBarLayout;

    invoke-virtual {p1}, Lcom/google/android/material/appbar/AppBarLayout;->getY()F

    move-result p1

    iget-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$AppBar:Lcom/google/android/material/appbar/AppBarLayout;

    invoke-virtual {p2}, Lcom/google/android/material/appbar/AppBarLayout;->getTotalScrollRange()I

    move-result p2

    int-to-float p2, p2

    div-float/2addr p1, p2

    .line 231
    iget-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$expanded_title:Landroid/widget/TextView;

    const/high16 v0, 0x40000000    # 2.0f

    mul-float/2addr v0, p1

    const/high16 v1, -0x40800000    # -1.0f

    mul-float/2addr v0, v1

    const/high16 v2, 0x3f800000    # 1.0f

    sub-float/2addr v2, v0

    invoke-virtual {p2, v2}, Landroid/widget/TextView;->setAlpha(F)V

    .line 232
    iget-object p2, p0, Lde/dylt/yanndroid/screenresolution/MainActivity$3;->val$collapsed_title:Landroid/widget/TextView;

    mul-float/2addr p1, v1

    invoke-virtual {p2, p1}, Landroid/widget/TextView;->setAlpha(F)V

    return-void
.end method
