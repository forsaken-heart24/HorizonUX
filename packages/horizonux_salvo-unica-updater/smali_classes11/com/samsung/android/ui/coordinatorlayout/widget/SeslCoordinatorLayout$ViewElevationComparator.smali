.class public Lcom/samsung/android/ui/coordinatorlayout/widget/SeslCoordinatorLayout$ViewElevationComparator;
.super Ljava/lang/Object;
.source "SeslCoordinatorLayout.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/coordinatorlayout/widget/SeslCoordinatorLayout;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "ViewElevationComparator"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Landroid/view/View;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 2337
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2338
    return-void
.end method


# virtual methods
.method public compare(Landroid/view/View;Landroid/view/View;)I
    .locals 3
    .param p1, "var1"    # Landroid/view/View;
    .param p2, "var2"    # Landroid/view/View;

    .line 2341
    invoke-static {p1}, Landroidx/core/view/ViewCompat;->getZ(Landroid/view/View;)F

    move-result v0

    .line 2342
    .local v0, "var3":F
    invoke-static {p2}, Landroidx/core/view/ViewCompat;->getZ(Landroid/view/View;)F

    move-result v1

    .line 2343
    .local v1, "var4":F
    cmpl-float v2, v0, v1

    if-lez v2, :cond_0

    .line 2344
    const/4 v2, -0x1

    return v2

    .line 2346
    :cond_0
    cmpg-float v2, v0, v1

    if-gez v2, :cond_1

    const/4 v2, 0x1

    goto :goto_0

    :cond_1
    const/4 v2, 0x0

    :goto_0
    return v2
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 2336
    check-cast p1, Landroid/view/View;

    check-cast p2, Landroid/view/View;

    invoke-virtual {p0, p1, p2}, Lcom/samsung/android/ui/coordinatorlayout/widget/SeslCoordinatorLayout$ViewElevationComparator;->compare(Landroid/view/View;Landroid/view/View;)I

    move-result p1

    return p1
.end method
