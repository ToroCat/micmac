#pragma once

#include "GpGpu/GpGpu_Data.h"

/// \struct pCorGpu
/// \param  La structure contenant tous les parametres necessaires a la correlation
struct pCorGpu
{

    /// \brief  Le nombre de Z calculer en parallele
    uint        ZCInter;

    /// \brief  Dimension du bloque terrain
    uint2       dimTer;

    /// \brief  Dimension du bloque terrain + halo
    uint2       dimDTer;

    /// \brief  Dimension du bloque terrain + halo sous echantillon�
    uint2       dimSTer;

    /// \brief  Dimension de l'image la plus grande
    uint2       dimImg;

    /// \brief  Dimension cache des calculs interm�diaires
    uint2       dimCach;

    /// \brief  Dimension de la vignette
    uint2       dimVig;

    /// \brief  Rayon de la vignette
    uint2       rayVig;

    /// \brief  Taille de la vignette en pixel
    uint        sizeVig;

    /// \brief  Taille du bloque terrain + halo
    uint        sizeDTer;

    /// \brief  taille reel du terrain
    uint        sizeTer;

    /// \brief  Taille du bloque terrain + halo sous echantillon�
    uint        sizeSTer;

    /// \brief  Taille du cache
    uint        sizeCach;

    /// \brief  Taille du cache des tous les Z
    uint        sizeCachAll;

    /// \brief  Pas echantillonage du terrain
    uint        sampProj;

    /// \brief  Valeur incorrect
    float       floatDefault;

    /// \brief  Valeur entiere incorrect
    int         IntDefault;

    /// \brief  Nombre d'images
    uint        nbImages;

    /// \brief  Rectangle du terrain dilat� du rayon de la vignette
    Rect        rDTer;

    /// \brief  Rectangle du terrain
    Rect        rTer;

    /// \brief  Epsilon
    float       mAhEpsilon;

    /// \brief  ptDTer
    ///
    uint2       ptDTer;

    /// \brief  Renvoie le rectangle du terrain dilat� du rayon de la vignette
    Rect        RDTer() { return rDTer; }

    /// \brief  Renvoie le rectangle du terrain
    Rect        RTer() { return rTer; }

    /// \brief  Initialise le rectangle du terrain et le nombre de Z a calculer
    void        SetDimension(Rect Ter, uint Zinter = INTERZ)
    {

        rTer		= Ter;

        rDTer		= Rect(Ter.pt0 - rayVig,Ter.pt1 + rayVig);

        dimTer		= rTer.dimension();

        dimDTer     = rDTer.dimension();

        dimSTer     = iDivUp(dimDTer,sampProj)+1;	// Dimension du bloque terrain sous echantillon�

        dimCach     = dimTer * dimVig;

        sizeDTer	= size(dimDTer);				// Taille du bloque terrain

        sizeSTer	= size(dimSTer);                // Taille du bloque terrain sous echantillon�

        sizeTer     = size(dimTer);

        sizeCach	= size(dimCach);

        sizeCachAll	= sizeCach * nbImages;

        ZCInter     = Zinter;

        //ptDTer      = pt;

    }

    void        SetZCInter(uint Zinter = INTERZ)
    {
        ZCInter     = Zinter;
    }

    /// \brief  Initialise les param?tres invariants pendant le calcul
    void SetParamInva(uint2 dV,uint2 dRV, uint2 dI, float tmAhEpsilon, uint samplingZ, int uvINTDef, uint nLayer)
    {
        float uvDef;
        memset(&uvDef,uvINTDef,sizeof(float));

        nbImages		= nLayer;

        dimVig			= dV;							// Dimension de la vignette

        dimImg			= dI;							// Dimension des images

        rayVig			= dRV;							// Rayon de la vignette

        sizeVig         = size(dV);						// Taille de la vignette en pixel

        sampProj		= samplingZ;					// Pas echantillonage du terrain

        floatDefault	= uvDef;						// UV Terrain incorrect

        IntDefault		= uvINTDef;

        mAhEpsilon		= tmAhEpsilon;       

    }

    /// \brief Renvoie vraie si le masque existe
    bool MaskNoNULL()
    {
        return (rTer.pt0.x != -1);
    }

    /// \brief Affiche tous les parametres dans la console
    void outConsole()
    {
        std::cout << "Parametre de calcul GPU pour la correlation symetrique\n";
        std::cout << "\n";
        std::cout << "----------------------------------------------------------\n";
        std::cout << "ZLocInter             : " << ZCInter << "\n";
        std::cout << "Dim Reel Terrain      : " << GpGpuTools::toStr(dimTer) << "\n";
        std::cout << "Dim calcul Terrain    : " << GpGpuTools::toStr(dimDTer) << "\n";
        std::cout << "Dim calcul Ter Samp   : " << GpGpuTools::toStr(dimSTer) << "\n";
        std::cout << "Dim vignette          : " << GpGpuTools::toStr(dimVig) << "\n";
        std::cout << "Rayon vignette        : " << GpGpuTools::toStr(rayVig) << "\n";
        std::cout << "Dim Image             : " << GpGpuTools::toStr(dimImg) << "\n";
        std::cout << "Dim Cache             : " << GpGpuTools::toStr(dimCach) << "\n";
        std::cout << "Taille vignette       : " << sizeVig << "\n";
        std::cout << "Taille terrain + halo : " << sizeDTer << "\n";
        std::cout << "Taille Reel Terrain   : " << sizeTer << "\n";
        std::cout << "Taille Samp Terrain   : " << sizeSTer << "\n";
        std::cout << "Taille cache          : " << sizeCach << "\n";
        std::cout << "Sample                : " << sampProj << "\n";
        std::cout << "Default Val float     : " << floatDefault << "\n";
        std::cout << "Default Val int       : " << IntDefault << "\n";
        std::cout << "Nombre Images         : " << nbImages << "\n";
        std::cout << "mAhEpsilon            : " << mAhEpsilon << "\n";
        std::cout << "Rectangle terrain     : ";rDTer.out();std::cout << "\n";
        std::cout << "Rectangle masque      : ";rTer.out();std::cout << "\n";
        std::cout << "\n";
        std::cout << "----------------------------------------------------------\n";
    }
};