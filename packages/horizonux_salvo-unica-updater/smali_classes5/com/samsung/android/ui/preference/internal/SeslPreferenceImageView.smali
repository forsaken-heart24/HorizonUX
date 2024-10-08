.class public Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;
.super Landroid/widget/ImageView;
.source "SeslPreferenceImageView.java"


# instance fields
.field private mMaxHeight:I

.field private mMaxWidth:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .line 32
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 33
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .line 36
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 37
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .line 40
    invoke-direct {p0, p1, p2, p3}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 28
    const v0, 0x7fffffff

    iput v0, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxWidth:I

    .line 29
    iput v0, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxHeight:I

    .line 41
    sget-object v1, Lcom/mesalabs/ten/update/R$styleable;->SeslPreferenceImageView:[I

    const/4 v2, 0x0

    invoke-virtual {p1, p2, v1, p3, v2}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[III)Landroid/content/res/TypedArray;

    move-result-object v1

    .line 42
    .local v1, "a":Landroid/content/res/TypedArray;
    const/4 v2, 0x3

    invoke-virtual {v1, v2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v2

    invoke-virtual {p0, v2}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->setMaxWidth(I)V

    .line 43
    const/4 v2, 0x2

    invoke-virtual {v1, v2, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->setMaxHeight(I)V

    .line 44
    invoke-virtual {v1}, Landroid/content/res/TypedArray;->recycle()V

    .line 45
    return-void
.end method


# virtual methods
.method public getMaxHeight()I
    .locals 1

    .line 66
    iget v0, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxHeight:I

    return v0
.end method

.method public getMaxWidth()I
    .locals 1

    .line 55
    iget v0, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxWidth:I

    return v0
.end method

.method protected onMeasure(II)V
    .locals 6
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .line 71
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v0

    .line 72
    .local v0, "widthMode":I
    const v1, 0x7fffffff

    const/high16 v2, -0x80000000

    if-eq v0, v2, :cond_0

    if-nez v0, :cond_2

    .line 73
    :cond_0
    invoke-static {p1}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v3

    .line 74
    .local v3, "widthSize":I
    invoke-virtual {p0}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->getMaxWidth()I

    move-result v4

    .line 75
    .local v4, "maxWidth":I
    if-eq v4, v1, :cond_2

    if-lt v4, v3, :cond_1

    if-nez v0, :cond_2

    .line 76
    :cond_1
    invoke-static {v4, v2}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result p1

    .line 80
    .end local v3    # "widthSize":I
    .end local v4    # "maxWidth":I
    :cond_2
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v3

    .line 81
    .local v3, "heightMode":I
    if-eq v3, v2, :cond_3

    if-nez v3, :cond_5

    .line 82
    :cond_3
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v4

    .line 83
    .local v4, "heightSize":I
    invoke-virtual {p0}, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->getMaxHeight()I

    move-result v5

    .line 84
    .local v5, "maxHeight":I
    if-eq v5, v1, :cond_5

    if-lt v5, v4, :cond_4

    if-nez v3, :cond_5

    .line 85
    :cond_4
    invoke-static {v5, v2}, Landroid/view/View$MeasureSpec;->makeMeasureSpec(II)I

    move-result p2

    .line 89
    .end local v4    # "heightSize":I
    .end local v5    # "maxHeight":I
    :cond_5
    invoke-super {p0, p1, p2}, Landroid/widget/ImageView;->onMeasure(II)V

    .line 90
    return-void
.end method

.method public setMaxHeight(I)V
    .locals 0
    .param p1, "maxHeight"    # I

    .line 60
    iput p1, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxHeight:I

    .line 61
    invoke-super {p0, p1}, Landroid/widget/ImageView;->setMaxHeight(I)V

    .line 62
    return-void
.end method

.method public setMaxWidth(I)V
    .locals 0
    .param p1, "maxWidth"    # I

    .line 49
    iput p1, p0, Lcom/samsung/android/ui/preference/internal/SeslPreferenceImageView;->mMaxWidth:I

    .line 50
    invoke-super {p0, p1}, Landroid/widget/ImageView;->setMaxWidth(I)V

    .line 51
    return-void
.end method
