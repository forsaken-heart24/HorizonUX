.class public Lcom/samsung/android/ui/view/animation/SineInOut80;
.super Landroid/view/animation/PathInterpolator;
.source "SineInOut80.java"


# direct methods
.method public constructor <init>()V
    .locals 4

    .line 22
    const v0, 0x3ea8f5c3    # 0.33f

    const/4 v1, 0x0

    const v2, 0x3e4ccccd    # 0.2f

    const/high16 v3, 0x3f800000    # 1.0f

    invoke-direct {p0, v0, v1, v2, v3}, Landroid/view/animation/PathInterpolator;-><init>(FFFF)V

    .line 23
    return-void
.end method
