.class Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;
.super Ljava/lang/Object;
.source "SeslAppCompatSpinner.java"

# interfaces
.implements Landroid/widget/ListAdapter;
.implements Landroid/widget/SpinnerAdapter;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/appcompat/widget/SeslAppCompatSpinner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DropDownAdapter"
.end annotation


# instance fields
.field private mAdapter:Landroid/widget/SpinnerAdapter;

.field private mListAdapter:Landroid/widget/ListAdapter;


# direct methods
.method public constructor <init>(Landroid/widget/SpinnerAdapter;Landroid/content/res/Resources$Theme;)V
    .locals 2
    .param p1, "adapter"    # Landroid/widget/SpinnerAdapter;
    .param p2, "dropDownTheme"    # Landroid/content/res/Resources$Theme;

    .line 514
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 515
    iput-object p1, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    .line 517
    instance-of v0, p1, Landroid/widget/ListAdapter;

    if-eqz v0, :cond_0

    .line 518
    move-object v0, p1

    check-cast v0, Landroid/widget/ListAdapter;

    iput-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mListAdapter:Landroid/widget/ListAdapter;

    .line 521
    :cond_0
    if-eqz p2, :cond_2

    .line 522
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_1

    instance-of v0, p1, Landroid/widget/ThemedSpinnerAdapter;

    if-eqz v0, :cond_1

    .line 524
    move-object v0, p1

    check-cast v0, Landroid/widget/ThemedSpinnerAdapter;

    .line 525
    .local v0, "themedAdapter":Landroid/widget/ThemedSpinnerAdapter;
    invoke-interface {v0}, Landroid/widget/ThemedSpinnerAdapter;->getDropDownViewTheme()Landroid/content/res/Resources$Theme;

    move-result-object v1

    if-eq v1, p2, :cond_2

    .line 526
    invoke-interface {v0, p2}, Landroid/widget/ThemedSpinnerAdapter;->setDropDownViewTheme(Landroid/content/res/Resources$Theme;)V

    goto :goto_0

    .line 528
    .end local v0    # "themedAdapter":Landroid/widget/ThemedSpinnerAdapter;
    :cond_1
    instance-of v0, p1, Landroidx/appcompat/widget/ThemedSpinnerAdapter;

    if-eqz v0, :cond_2

    .line 529
    move-object v0, p1

    check-cast v0, Landroidx/appcompat/widget/ThemedSpinnerAdapter;

    .line 530
    .local v0, "themedAdapter":Landroidx/appcompat/widget/ThemedSpinnerAdapter;
    invoke-interface {v0}, Landroidx/appcompat/widget/ThemedSpinnerAdapter;->getDropDownViewTheme()Landroid/content/res/Resources$Theme;

    move-result-object v1

    if-nez v1, :cond_2

    .line 531
    invoke-interface {v0, p2}, Landroidx/appcompat/widget/ThemedSpinnerAdapter;->setDropDownViewTheme(Landroid/content/res/Resources$Theme;)V

    nop

    .line 535
    .end local v0    # "themedAdapter":Landroidx/appcompat/widget/ThemedSpinnerAdapter;
    :cond_2
    :goto_0
    return-void
.end method


# virtual methods
.method public areAllItemsEnabled()Z
    .locals 2

    .line 584
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mListAdapter:Landroid/widget/ListAdapter;

    .line 585
    .local v0, "adapter":Landroid/widget/ListAdapter;
    if-eqz v0, :cond_0

    .line 586
    invoke-interface {v0}, Landroid/widget/ListAdapter;->areAllItemsEnabled()Z

    move-result v1

    return v1

    .line 588
    :cond_0
    const/4 v1, 0x1

    return v1
.end method

.method public getCount()I
    .locals 1

    .line 539
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-interface {v0}, Landroid/widget/SpinnerAdapter;->getCount()I

    move-result v0

    :goto_0
    return v0
.end method

.method public getDropDownView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 1
    .param p1, "position"    # I
    .param p2, "convertView"    # Landroid/view/View;
    .param p3, "parent"    # Landroid/view/ViewGroup;

    .line 559
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    .line 560
    :cond_0
    invoke-interface {v0, p1, p2, p3}, Landroid/widget/SpinnerAdapter;->getDropDownView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 559
    :goto_0
    return-object v0
.end method

.method public getItem(I)Ljava/lang/Object;
    .locals 1
    .param p1, "position"    # I

    .line 544
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-interface {v0, p1}, Landroid/widget/SpinnerAdapter;->getItem(I)Ljava/lang/Object;

    move-result-object v0

    :goto_0
    return-object v0
.end method

.method public getItemId(I)J
    .locals 2
    .param p1, "position"    # I

    .line 549
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-nez v0, :cond_0

    const-wide/16 v0, -0x1

    goto :goto_0

    :cond_0
    invoke-interface {v0, p1}, Landroid/widget/SpinnerAdapter;->getItemId(I)J

    move-result-wide v0

    :goto_0
    return-wide v0
.end method

.method public getItemViewType(I)I
    .locals 1
    .param p1, "position"    # I

    .line 604
    const/4 v0, 0x0

    return v0
.end method

.method public getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
    .locals 1
    .param p1, "position"    # I
    .param p2, "convertView"    # Landroid/view/View;
    .param p3, "parent"    # Landroid/view/ViewGroup;

    .line 554
    invoke-virtual {p0, p1, p2, p3}, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->getDropDownView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method public getViewTypeCount()I
    .locals 1

    .line 609
    const/4 v0, 0x1

    return v0
.end method

.method public hasStableIds()Z
    .locals 1

    .line 565
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Landroid/widget/SpinnerAdapter;->hasStableIds()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isEmpty()Z
    .locals 1

    .line 614
    invoke-virtual {p0}, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->getCount()I

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isEnabled(I)Z
    .locals 2
    .param p1, "position"    # I

    .line 594
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mListAdapter:Landroid/widget/ListAdapter;

    .line 595
    .local v0, "adapter":Landroid/widget/ListAdapter;
    if-eqz v0, :cond_0

    .line 596
    invoke-interface {v0, p1}, Landroid/widget/ListAdapter;->isEnabled(I)Z

    move-result v1

    return v1

    .line 598
    :cond_0
    const/4 v1, 0x1

    return v1
.end method

.method public registerDataSetObserver(Landroid/database/DataSetObserver;)V
    .locals 1
    .param p1, "observer"    # Landroid/database/DataSetObserver;

    .line 570
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-eqz v0, :cond_0

    .line 571
    invoke-interface {v0, p1}, Landroid/widget/SpinnerAdapter;->registerDataSetObserver(Landroid/database/DataSetObserver;)V

    .line 573
    :cond_0
    return-void
.end method

.method public unregisterDataSetObserver(Landroid/database/DataSetObserver;)V
    .locals 1
    .param p1, "observer"    # Landroid/database/DataSetObserver;

    .line 577
    iget-object v0, p0, Landroidx/appcompat/widget/SeslAppCompatSpinner$DropDownAdapter;->mAdapter:Landroid/widget/SpinnerAdapter;

    if-eqz v0, :cond_0

    .line 578
    invoke-interface {v0, p1}, Landroid/widget/SpinnerAdapter;->unregisterDataSetObserver(Landroid/database/DataSetObserver;)V

    .line 580
    :cond_0
    return-void
.end method
